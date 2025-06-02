// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:spatch_flutter/components/cash_widget.dart';
import 'package:spatch_flutter/components/note_widget.dart';
import 'package:spatch_flutter/components/request_button.dart';

class GuestVehicle extends StatefulWidget {
  // final Function(String, String) onVehicleSelected;
  final Future<bool> Function() sendDataToFirestore; // 🔹 Function from parent
  final VoidCallback onRequestSend;
  // final VoidCallback onPaystackPayment;

  final Function(String vehicleName, String vehiclePrice) onVehicleSelected;
  final Future<void> Function() onPaystackPayment;
  const GuestVehicle({
    super.key,
    required this.onVehicleSelected,
    required this.sendDataToFirestore,
    required this.onRequestSend,
    required this.onPaystackPayment,
  });

  @override
  State<GuestVehicle> createState() => _GuestVehicleState();
}

class _GuestVehicleState extends State<GuestVehicle> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  bool _isDropDownVisible = false;
  String _selectedVehicleName = "";
  String _selectedVehiclePrice = "";
  String? email;
  final emailController = TextEditingController();
  final amountController = TextEditingController();
  String publicKey = 'pk_test_833b6de11001e94ae541494882d24c484b83c04a';

  String message = '';

  @override
  final List<Map<String, dynamic>> vehicles = [
    {
      'name': 'Bike',
      'price': '2,240',
      "imagePath": "lib/images/bike_image.png",
    },
    {
      'name': 'Van',
      'price': '4,300',
      "imagePath": "lib/images/van_image.png",
    },
  ];

  get onRequestSend => null;

  Future<void> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() => email = "${userDoc['email']}");
      }
    }
  }

  String generateRef() {
    final randomCode = Random().nextInt(123456);
    return 'ref-$randomCode';
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    amountController.addListener(() => setState(() {}));
  }

  void _toggleDropdown() {
    setState(() => _isDropDownVisible = !_isDropDownVisible);
  }

  void _selectVehicle(String vehicleName, String vehiclePrice) {
    setState(() {
      _selectedVehicleName = vehicleName;
      _selectedVehiclePrice = vehiclePrice;
      _isDropDownVisible = false;
    });
    widget.onVehicleSelected(vehicleName, vehiclePrice);
  }

  // Future<void> _handlePaystackPayment() async {
  //   if (email == null || email!.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Email not found. Please log in again.")),
  //     );
  //     return;
  //   }

  //   if (_selectedVehiclePrice.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please select a vehicle first.")),
  //     );
  //     return;
  //   }

  //   final ref = generateRef();
  //   final cleanAmount = int.tryParse(_selectedVehiclePrice.replaceAll(',', ''));

  //   if (cleanAmount == null || cleanAmount <= 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Invalid vehicle amount.")),
  //     );
  //     return;
  //   }

  //   try {
  //     await FlutterPaystackPlus.openPaystackPopup(
  //       publicKey: "pk_test_833b6de11001e94ae541494882d24c484b83c04a",
  //       secretKey: "sk_test_2328681dd92eec15b30f1a5d6375df69067109ef",
  //       context: context,
  //       currency: 'NGN',
  //       customerEmail: email!,
  //       amount: (cleanAmount * 100).toString(),
  //       reference: ref,
  //       callBackUrl: "[GET IT FROM YOUR PAYSTACK DASHBOARD]",
  //       onClosed: () {
  //         debugPrint('Payment popup closed without finishing');
  //         return ();
  //       },
  //       onSuccess: () async {
  //         debugPrint('Payment successful');
  //         try {
  //           // Log payment details for debugging
  //           debugPrint(
  //               'Payment success: Reference - $ref, Amount - $cleanAmount');
  //           await widget.sendDataToFirestore();
  //         } catch (e) {
  //           debugPrint("Error during Firestore data submission: $e");
  //           return ();
  //         }
  //         return ();
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint("Payment error: \$e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Payment error: \$e")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Image.asset(
                  "lib/images/bike.png",
                  color: _isDropDownVisible ? Colors.grey : Colors.black,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _selectedVehicleName.isEmpty
                            ? "Select vehicle category"
                            : "$_selectedVehicleName . ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      if (_selectedVehicleName
                          .isNotEmpty) // Only show price when selected
                        TextSpan(
                          text: "NGN $_selectedVehiclePrice",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF12AA6C)),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset(
                    _isDropDownVisible
                        ? "lib/images/drop.png"
                        : "lib/images/drop2.png",
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isDropDownVisible)
          Column(
            children: vehicles.map((vehicle) {
              bool isSelected = _selectedVehicleName == vehicle['name'];
              return GestureDetector(
                onTap: () => _selectVehicle(vehicle['name'], vehicle['price']),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isSelected ? Color(0xFF12AA6C) : Colors.white,
                        width: 0.5),
                    color: isSelected ? Colors.white : Colors.grey.shade200,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                          Text(
                            'Price ${vehicle['price']}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected ? Color(0xFF12AA6C) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        vehicle["imagePath"],
                        height: 50,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        SizedBox(
          height: 20,
        ),
        NoteWidget(
          controller: noteController,
        ),
        SizedBox(
          height: 20,
        ),
        CashWidget(
          controller: cashController,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: _selectedVehicleName.isEmpty
                      ? Text("NGN",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12AA6C),
                              letterSpacing: 0))
                      : Text(
                          "N$_selectedVehiclePrice",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12AA6C),
                              letterSpacing: 0),
                        ),
                ),
                GestureDetector(
                  onTap: () async {
                    bool success = await widget.sendDataToFirestore();
                    if (success) {
                      await widget
                          .onPaystackPayment(); // 🔹 Call the Paystack logic from parent
                    }
                  },
                  child: RequestButton(
                    text: "Request Spatch",
                    color: Color(0xFF12AA6C),
                    fontcolor: Colors.white,
                    border: Border(),
                    icon: Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
