const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

const PAYSTACK_SECRET_KEY = "sk_test_xxxx"; // Replace with your Paystack secret key

exports.processPaymentOnAccept = functions.firestore
  .document("dispatch_requests/{dispatchId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Only proceed if status changed from 'pending' to 'accepted'
    if (before.status === "pending" && after.status === "accepted") {
      const paymentRef = after.payment_reference;
      const amount = after.vehicle_price;
      const riderId = after.rider_id;

      if (!paymentRef || !amount || !riderId) {
        console.error("Missing payment reference, amount, or rider ID.");
        return null;
      }

      try {
        // 1. Charge the user (capture payment)
        const chargeResponse = await axios.post(
          "https://api.paystack.co/transaction/verify/" + paymentRef,
          {},
          {
            headers: {
              Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
              "Content-Type": "application/json",
            },
          }
        );

        const chargeData = chargeResponse.data;

        if (!chargeData.status || chargeData.data.status !== "success") {
          throw new Error("Transaction not successful or not verified.");
        }

        // 2. Transfer to rider (via Paystack Transfer API)
        const transferResponse = await axios.post(
          "https://api.paystack.co/transfer",
          {
            source: "balance",
            amount: amount * 100, // in kobo
            recipient: after.rider_paystack_recipient_code, // this must be set
            reason: `Dispatch payment for ID ${context.params.dispatchId}`,
          },
          {
            headers: {
              Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
              "Content-Type": "application/json",
            },
          }
        );

        const transferData = transferResponse.data;

        // 3. Update Firestore with payment status
        await admin
          .firestore()
          .collection("dispatch_requests")
          .doc(context.params.dispatchId)
          .update({
            payment_status: "completed",
            transfer_reference: transferData.data.reference,
          });

        return null;
      } catch (error) {
        console.error("Payment processing failed:", error.message);

        await admin
          .firestore()
          .collection("dispatch_requests")
          .doc(context.params.dispatchId)
          .update({
            payment_status: "failed",
          });

        return null;
      }
    }

    return null;
  });
