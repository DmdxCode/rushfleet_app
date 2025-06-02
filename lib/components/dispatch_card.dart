// ignore_for_file: annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spatch_flutter/components/rushfleet_alert_dialog.dart';
import 'package:spatch_flutter/pages/view_details_page.dart';

class DispatchCard extends StatefulWidget {
  final Map<String, dynamic> request;

  final String dispatchId;
  final Function(String) onDelete;
  const DispatchCard({
    Key? key,
    required this.request,
    required this.dispatchId,
    required this.onDelete,
  }) : super(key: key);
  @override
  State<DispatchCard> createState() => _DispatchCardState();
}

class _DispatchCardState extends State<DispatchCard> {
  String? username;
  bool _isDropDownVisible = false;
  @override
  void initState() {
    super.initState();
    if (username == null) {
      getUsername();
    }
  }

  Future<void> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();

      if (userDoc.exists && mounted) {
        // <-- Check for mounted here
        setState(() {
          username = "${userDoc['first_name']} ${userDoc['last_name']}";
        });
      }
    }
  }

  Future<void> deleteDispatch(String dispatchId) async {
    try {
      await FirebaseFirestore.instance
          .collection('dispatch_requests')
          .doc(dispatchId)
          .delete();

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => RushFleetAlertDialog(
            title: 'lib/images/correct.png',
            message: 'Dispatch record deleted successfully.',
            confirmText: 'Ok',
            onConfirm: () {}),
      );

      // Optionally pop the current screen or refresh the state
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => RushFleetAlertDialog(
            title: 'lib/images/cancle.png',
            message: 'Error deleting dispatch record: $e',
            confirmText: 'Ok',
            onConfirm: () {}),
      );
    }
  }

// Format price as NGN 2,800.00
  String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'en_NG', // Use Nigerian locale
      symbol: "NGN ",
      decimalDigits: 2, // Two decimal places
    );
    return formatter.format(price);
  }

  Widget build(BuildContext context) {
    // Safely handle null values
    String formattedDate = widget.request["timestamp"] != null
        ? DateFormat("dd MMMM yyyy, hh:mm a")
            .format(widget.request["timestamp"])
        : "Unknown Date";
    String priceString = widget.request["total_price"]?.toString() ?? "0.00";
    double price = double.tryParse(priceString.replaceAll(',', '')) ??
        0.0; // Remove commas & convert

    String pickupAddress = widget.request["pickup_address"] ?? "Unknown";
    String deliveryName = widget.request["delivery_name"] ?? "Unknown";
    String deliveryAddress = widget.request["delivery_address"] ?? "Unknown";
    String status = widget.request["status"] ?? "Completed";
    String orderId = widget.request["order_id"] ?? "Completed";
    String selectedVehicle = widget.request["selected_vehicle"] ?? "";
    Color statusColor = status == "Canceled" ? Colors.red : Colors.black;

    Widget vehicleImageWidget;
    if (widget.request["selected_vehicle"] == "Bike") {
      vehicleImageWidget = Image.asset(
        "lib/images/bike_image.png",
        height: 80,
        width: 80,
      );
    } else if (widget.request["selected_vehicle"] == "Van") {
      vehicleImageWidget = Image.asset(
        "lib/images/van_image.png",
        height: 80,
        width: 80,
      );
    } else {
      vehicleImageWidget = const SizedBox(); // or a default image
    }

    void toggleDropdown() {
      setState(() {
        _isDropDownVisible = !_isDropDownVisible;
      });
    }

    return Container(
      decoration: BoxDecoration(
          border: _isDropDownVisible
              ? Border.all(width: 0.5, color: Colors.grey)
              : Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                ),
          borderRadius: _isDropDownVisible
              ? BorderRadius.circular(15)
              : BorderRadius.zero),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Price
            GestureDetector(
              onTap: toggleDropdown,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: _isDropDownVisible
                            ? BorderSide(width: 0.5, color: Colors.grey)
                            : BorderSide.none)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formattedDate, style: TextStyle(color: Colors.grey)),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatPrice(price),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: statusColor),
                        ),
                        Row(
                          children: [
                            Text(
                              orderId,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            // Image.asset(
                            //   "lib/images/cash.png",
                            //   height: 23,
                            //   color: Color(0xff2F8A00),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    _isDropDownVisible
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            if (_isDropDownVisible)
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        color: Color(0xffFF9E00),
                        "lib/images/up-arrow.png",
                        height: 20,
                      ),
                      SizedBox(height: 15),
                      Image.asset(
                        "lib/images/dots.png",
                        height: 35,
                      ),
                      SizedBox(height: 15),
                      Image.asset(
                        color: Color(0xFF12AA6C),
                        "lib/images/downloadrf.png",
                        height: 20,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.grey))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(children: [
                                  SizedBox(width: 5),
                                  Text("Picked From",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                ]),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(username.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13)),
                                        Text(
                                          pickupAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Row(children: [
                            SizedBox(width: 5),
                            Text("Delivered To",
                                style: TextStyle(
                                    color: Color(0xFF12AA6C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10)),
                          ]),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(deliveryName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          )),
                                      Text(
                                        deliveryAddress,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  vehicleImageWidget
                ],
              ),
            SizedBox(height: 15),

            // Payment Method & Status

            if (_isDropDownVisible)
              // View Receipt

              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewDetailsPage(
                                          dispatchId: widget.dispatchId),
                                    ),
                                  );
                                },
                                child: Text(
                                  "View receipt detail",
                                  style: TextStyle(
                                      color: Color(0xFF12AA6C),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                  color: Color(0xFF12AA6C),
                                  "lib/images/next.png"),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(Size(30, 20)),
                            backgroundColor: WidgetStateProperty.all(
                                Colors.redAccent), // Custom background color
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10)), // Custom padding
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            ))),
                        onPressed: () async {
                          // Show confirmation dialog
                          final bool? confirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color((0XFFD4E9E2)),
                                title: Text('Delete History'),
                                content: Text(
                                    'Are you sure you want to delete this record?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel',
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // User canceled
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User confirmed deletion
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          // If user confirms, delete the dispatch
                          if (confirmed == true) {
                            widget.onDelete(
                                widget.dispatchId); // Call the delete function
                            // Optionally, you might want to show a Snackbar or some visual feedback

                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => RushFleetAlertDialog(
                                  title: 'lib/images/correct.png',
                                  message:
                                      'Dispatch record deleted successfully.',
                                  confirmText: 'Ok',
                                  onConfirm: () {
                                    Navigator.pop(context);
                                  }),
                            );
                          }
                        },
                        child: Image.asset(
                          color: Colors.white,
                          "lib/images/info.png",
                          height: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
