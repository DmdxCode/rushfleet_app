import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spatch_flutter/components/reciept_logo.dart';
import 'package:spatch_flutter/components/reciept_socials.dart';
import 'package:spatch_flutter/components/socials.dart';
import 'package:spatch_flutter/components/spatch_logo.dart';
import 'package:spatch_flutter/pages/history_page.dart';
import 'package:spatch_flutter/pages/wallet_page.dart';

class ViewDetailsPage extends StatefulWidget {
  final String dispatchId;

  ViewDetailsPage({
    Key? key,
    required this.dispatchId,
  }) : super(key: key);

  @override
  State<ViewDetailsPage> createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  String? username;
  String? _currentOrderId;

  @override
  void initState() {
    super.initState();
    getUsername();
    getOrderId();
  }

  Future<void> getOrderId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("dispatch_requests")
        .doc(widget.dispatchId)
        .get();

    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      _currentOrderId = data["order_id"]?.toString();
    });
  }

  Future<void> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc["first_name"];
        });
      }
    }
  }

  Future<Map<String, dynamic>?> fetchDispatchById() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("dispatch_requests")
        .doc(widget.dispatchId)
        .get();

    if (!doc.exists) return null;

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data["timestamp"] =
        (data["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now();

    return data;
  }

  // String formatPrice(double parsedAmount) {
  //   final formatter = NumberFormat.currency(
  //     locale: 'en_NG',
  //     symbol: "₦", // Or "NGN " if you prefer
  //     decimalDigits: 2,
  //   );
  //   return formatter.format(parsedAmount);
  // }

  @override
  Widget build(BuildContext context) {
    // Widget vehicleImageWidget = parsedAmount < 3000
    //     ? Image.asset("lib/images/bike_image.png", height: 80, width: 80)
    //     : Image.asset("lib/images/van_image.png", height: 80, width: 80);

    // double amount = double.tryParse(priceString.replaceAll(',', '')) ??
    //     0.0; // Remove commas & convert

    // Widget vehicleImageWidget;
    // if (amount < 3000) {
    //   vehicleImageWidget = Image.asset(
    //     "lib/images/bike_image.png",
    //     height: 80,
    //     width: 80,
    //   );
    // } else {
    //   vehicleImageWidget = Image.asset(
    //     "lib/images/van_image.png",
    //     height: 80,
    //     width: 80,
    //   );
    // }
    String formatPrice(double price) {
      final formatter = NumberFormat.currency(
        locale: 'en_NG', // Use Nigerian locale
        symbol: "NGN ",
        decimalDigits: 2, // Two decimal places
      );
      return formatter.format(price);
    }

    Offset center = Offset(200, 87.5);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF12AA6C),
          elevation: 0,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black, // Change status bar color to black
            statusBarIconBrightness: Brightness.light, // White icons
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HistoryPage()));
              },
              child: Icon(Icons.arrow_back_ios_new)),
          title: Text(
            _currentOrderId != null ? '$_currentOrderId' : 'Loading...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
            future: fetchDispatchById(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFF12AA6C),
                ));
              } else if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Text("No recent dispatch found."));
              }

              final dispatch = snapshot.data!;
              final formattedDate = DateFormat("dd MMMM yyyy, hh:mm a")
                  .format(dispatch["timestamp"]);
              // final rawAmount = dispatch["vehicle_price"];
              // if (rawAmount == null) {
              //   print("vehicle_price is missing from dispatch data");
              // }
              // final parsedAmount = rawAmount is num
              //     ? rawAmount.toDouble()
              //     : double.tryParse(rawAmount.toString()) ?? 0.0;
              String priceString =
                  dispatch["total_price"]?.toString() ?? "0.00";
              double price = double.tryParse(priceString.replaceAll(',', '')) ??
                  0.0; // Remove commas & convert

              final pickupAddress = dispatch["pick_up_address"] ?? "Unknown";
              final deliveryName = dispatch["contact_name"] ?? "Unknown";
              final deliveryAddress = dispatch["delivery_address"] ?? "Unknown";
              final item = dispatch["item_description"] ?? "Unknown";
              final status = dispatch['status'] ?? 'Pending';
              final orderId = dispatch['order_id'] ?? "NA";
              String selectedVehicle = dispatch["selected_vehicle"] ?? "";
              Widget vehicleImageWidget;
              if (dispatch["selected_vehicle"] == "Bike") {
                vehicleImageWidget = Image.asset(
                  "lib/images/bike_image.png",
                  height: 80,
                  width: 80,
                );
              } else if (dispatch["selected_vehicle"] == "Van") {
                vehicleImageWidget = Image.asset(
                  "lib/images/van_image.png",
                  height: 80,
                  width: 80,
                );
              } else {
                vehicleImageWidget = const SizedBox(); // or a default image
              }

              return Container(
                color: Color(0xfff2f2f2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          ClipPath(
                            clipper: ScallopClipper2(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFD4E9E2),
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              width: 400,
                              height: 200,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          color: Color(0xFF12AA6C),
                                          "lib/images/fast-delivery.png",
                                          height: 45,
                                        ),
                                        Image.asset(
                                          color: Color(0xFF12AA6C),
                                          "lib/images/Combined Shape.png",
                                          height: 110,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Hi $username,",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      "Thank you for \nchoosing",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                              TextSpan(
                                                  text: " RushFleet",
                                                  style: TextStyle(
                                                    color: Color(0xFF12AA6C),
                                                    fontSize: 20,
                                                  ))
                                            ],
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          "lib/images/package-box.png",
                                          color: Color(0xFF061F16),
                                          height: 45,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Color(0XFFD4E9E2),
                            width: 400,
                            height: 280,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0XFFD4E9E2),
                                        border: Border(
                                            bottom: BorderSide(width: 0.2))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(formattedDate,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Status",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatPrice(price),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    status,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0XFFD4E9E2),
                                        border: Border(
                                            bottom: BorderSide(width: 0.2))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              // Text(formattedDate,
                                              //     style: TextStyle(
                                              //         color: Colors.black,
                                              //         fontSize: 10)),
                                              // SizedBox(
                                              //   height: 5,
                                              // ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Item",
                                                style: TextStyle(
                                                  color: Color(0xFF12AA6C),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    item,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
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
                                                      padding: EdgeInsets.only(
                                                          bottom: 10),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  width: 0.5,
                                                                  color: Colors
                                                                      .grey))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(height: 10),
                                                          Row(children: [
                                                            SizedBox(width: 5),
                                                            Text("Picked From",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .orange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10)),
                                                          ]),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: SizedBox(
                                                              width: 200,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  Text(
                                                                      username
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              13)),
                                                                  Text(
                                                                    pickupAddress,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 20),
                                                    Row(children: [
                                                      SizedBox(width: 5),
                                                      Text("Delivered To",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF12AA6C),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10)),
                                                    ]),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 5,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 3,
                                                                ),
                                                                Text(
                                                                    deliveryName,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13,
                                                                    )),
                                                                Text(
                                                                  deliveryAddress,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11),
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
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: ScallopClipper(),
                            child: Container(
                              color: Color(0xFF061F16),
                              width: 400,
                              height: 175,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SizedBox(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left:
                                            80, // To center the image horizontally
                                        bottom: 0, // Align to the bottom
                                        child: Image.asset(
                                          height: 150,
                                          colorBlendMode: BlendMode.saturation,
                                          "lib/images/Combined Shape (1).png",
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RecieptLogo(),
                                          Divider(
                                            color: Colors.white,
                                            thickness: 0.5,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "4001A Plot C, Island Road, Ikoyi, Lagos. \n(c)2020 RushFleet Logistic LLC \nReport to Support Team ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                              Row(
                                                children: [
                                                  RecieptSocials(
                                                      iconPath:
                                                          "lib/images/instagram2.png"),
                                                  RecieptSocials(
                                                      iconPath:
                                                          "lib/images/twitter.png"),
                                                  RecieptSocials(
                                                      iconPath:
                                                          "lib/images/facebook2.png"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}

class ScallopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double radius = 10;

    // Start from top-left
    path.moveTo(0, 0);
    path.lineTo(0, size.height - radius);

    // Draw scallops along the bottom
    double x = 0;
    while (x < size.width) {
      path.arcToPoint(
        Offset(x + radius, size.height),
        radius: Radius.circular(radius),
        clockwise: true, // Flip the arc downward
      );
      x += radius * 2;
    }

    path.lineTo(size.width, size.height - radius);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ScallopClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double radius = 10;

    double x = 0;

    // Start with left edge
    path.moveTo(0, radius);

    // Draw scallops along the top edge
    while (x < size.width) {
      path.arcToPoint(
        Offset(x + radius, 0),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(x + radius * 2, radius),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      x += radius * 2;
    }

    // Draw rest of the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
