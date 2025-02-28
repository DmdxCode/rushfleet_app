// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:spatch_flutter/components/custom_drop_dow.dart';
// import 'package:spatch_flutter/components/drop_down_book_options.dart';

// class BookOptions extends StatefulWidget {
//   const BookOptions({super.key});

//   @override
//   State<BookOptions> createState() => _BookOptionsState();
// }

// class _BookOptionsState extends State<BookOptions> {
//   String? selectedVehicle; // Stores selected vehicle name
//   Map<String, dynamic>? selectedItem; // Stores full selected item details

//   final List<Map<String, dynamic>> items = [
//     {
//       "vehicle": "Bike",
//       "imagePath": "lib/images/bike_image.png",
//       "price": "N2400"
//     },
//     {
//       "vehicle": "Van",
//       "imagePath": "lib/images/van_image.png",
//       "price": "N4100"
//     },
//   ];
//   void handleSelection<T>(Map<String, dynamic> selectedItem) {
//     setState(() {
//       this.selectedItem = selectedItem;
//       selectedVehicle = selectedItem["vehicle"];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Expanded(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset(
//                   "lib/images/bike.png",
//                   height: 30,
//                 ),
//                 Text("Select Vehicle Category"),
//                 SizedBox(
//                   child: CustomDropdownItem<Map<String, dynamic>>(
//                     items: items,
//                     onItemSelected: handleSelection,
//                     itemBuilder: (item) => Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             children: [
//                               Text(item["vehicle"]),
//                               Text(item["price"]),
//                             ],
//                           ),
//                           Image.asset(
//                             item["imagePath"],
//                             width: 30,
//                             height: 30,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(color: Colors.amber),
//                             child: Column(
//                               children: [
//                                 if (selectedItem != null) ...[],
//                               ],
//                             ),
//                           )
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
