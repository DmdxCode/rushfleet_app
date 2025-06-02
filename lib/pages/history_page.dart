import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spatch_flutter/components/dispatch_card.dart';
import 'package:spatch_flutter/pages/home_page.dart';

class HistoryPage extends StatefulWidget {
  // Change to StatefulWidget
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = []; // Local list to hold the dispatches

  Future<List<Map<String, dynamic>>> fetchDispatchHistory() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in!");
      return [];
    }

    String userId = user.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("dispatch_requests")
        .where("customer_id", isEqualTo: userId) // Filter by logged-in user
        .orderBy("timestamp", descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return {
        "id": doc.id, // Use the actual document ID
        "timestamp":
            (data["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now(),
        "amount": data["vehicle_price"]?.toString() ?? "0.00",
        "pickup_name": data["contact_name"] ?? "Unknown",
        "pickup_address": data["pick_up_address"] ?? "Unknown",
        "delivery_name": data["contact_name"] ?? "Unknown",
        "delivery_address": data["delivery_address"] ?? "Unknown",
        "status": data["status"] ?? "Completed",
        "payment_method": data["payment_method"] ?? "Unknown",
        "order_id": data["order_id"] ?? "Unknown",
        "total_price": data["total_price"] ?? "Unknown",
        "selected_vehicle": data["selected_vehicle"] ?? "Unknown",
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    fetchDispatchHistory().then((data) {
      setState(() {
        history = data; // Initialize local history list with fetched data
      });
    });
  }

  Future<void> deleteDispatch(String dispatchId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in!");
      return; // If there is no user, return early
    }

    // Remove from Firestore
    await FirebaseFirestore.instance
        .collection("dispatch_requests")
        .doc(dispatchId)
        .delete()
        .then((_) {
      setState(() {
        history.removeWhere((dispatch) =>
            dispatch["id"] == dispatchId); // Remove from local history list
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xFF12AA6C),
        title: Text(
          "History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                  fullscreenDialog: true,
                ),
              );
            },
          );
        }),
      ),
      body: history.isEmpty
          ? Center(
              child: Text(
              "No History Found",
              style: TextStyle(fontSize: 15),
            ))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                var request = history[index];
                String dispatchId = request["id"]; // Get the ID you added above

                return DispatchCard(
                  request: request,
                  dispatchId: dispatchId, // Use the correct ID

                  onDelete:
                      deleteDispatch, // Pass the delete function as callback
                );
              },
            ),
    );
  }
}
