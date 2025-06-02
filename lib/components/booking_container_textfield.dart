import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/book_options.dart';
import 'package:spatch_flutter/components/booking_textfield.dart';
import 'package:spatch_flutter/components/custom_drop_dow.dart';
import 'package:spatch_flutter/components/row_textfield.dart';

class BookingContainerTextfield extends StatefulWidget {
  const BookingContainerTextfield({super.key});

  @override
  State<BookingContainerTextfield> createState() =>
      _BookingContainerTextfieldState();
}

class _BookingContainerTextfieldState extends State<BookingContainerTextfield> {
  String? selectedVehicle;
  Map<String, dynamic>? selectedItem;

  final List<Map<String, dynamic>> items = [
    {
      "vehicle": "Bike",
      "imagePath": "lib/images/bike_image.png",
      "price": "N2,240"
    },
    {
      "vehicle": "Van",
      "imagePath": "lib/images/van_image.png",
      "price": "N4,300"
    },
  ];

  void handleSelection(Map<String, dynamic> selectedItem) {
    setState(() {
      this.selectedItem = selectedItem;
      selectedVehicle = selectedItem["vehicle"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Pick-up Address
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("lib/images/pickup.png", height: 20),
                  ),
                  Expanded(
                    child: BookingTextfield(hintText: "Pick up address"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Image.asset("lib/images/cancle_icon.png", height: 10),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Delivery Details
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  RowTextfield(
                    imagePath: "lib/images/deliver.png",
                    text: "Where are we delivering to?",
                    iconPath: "lib/images/cancle_icon.png",
                  ),
                  RowTextfield(
                    imagePath: "lib/images/user2.png",
                    text: "Contact name",
                    iconPath: "lib/images/cancle_icon.png",
                  ),
                  RowTextfield(
                    imagePath: "lib/images/call.png",
                    text: "Contact number",
                    iconPath: "lib/images/cancle_icon.png",
                  ),
                  RowTextfield(
                    imagePath: "lib/images/item.png",
                    text: "Item",
                    iconPath: "lib/images/cancle_icon.png",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Dropdown Menu
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/images/bike.png",
                        height: 30,
                        width: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      selectedItem == null
                          ? Text(
                              "Select vehicle category",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(
                              selectedItem!["vehicle"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      Text("."),
                      const SizedBox(
                        width: 5,
                      ),
                      selectedItem == null
                          ? Text("")
                          : Text(selectedItem!["price"],
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7000F6)))
                    ],
                  ),
                  CustomDropdownItem<Map<String, dynamic>>(
                    onTap: () => handleSelection,
                    items: items,
                    itemBuilder: (item) => Container(
                      height: 100,
                      width: 50,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    onItemSelected: handleSelection,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Display Selected Vehicle Image & Price
            if (selectedItem != null) ...[
              // Center(

              //   child: Container(
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Color(0xFF7000F6),
              //           width: 0.5,
              //         ),
              //         borderRadius: BorderRadius.circular(10)),
              //     child: Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               Text(
              //                 "Price",
              //                 style: TextStyle(color: Color(0xFF7000F6)),
              //               ),
              //               const SizedBox(width: 5),
              //               Text(
              //                 selectedItem!["price"],
              //                 style: const TextStyle(
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.bold,
              //                   color: Color(0xFF7000F6),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(height: 10),
              //           Image.asset(
              //             selectedItem!["imagePath"],
              //             width: 50,
              //             height: 50,
              //             errorBuilder: (context, error, stackTrace) =>
              //                 const Icon(Icons.image_not_supported, size: 50),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
