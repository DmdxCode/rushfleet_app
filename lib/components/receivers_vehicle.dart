import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:spatch_flutter/components/cash_widget.dart';
import 'package:spatch_flutter/components/note_widget.dart';
import 'package:spatch_flutter/components/request_button.dart';

class ReceiversVehicle extends StatefulWidget {
  final Future<bool> Function() sendDataToFirestore;
  final VoidCallback onRequestSend;
  final Function(String name, String pricePerKm) onVehicleSelected;
  final TextEditingController noteController;
  final TextEditingController cashController;
  final double? calculatedTotalprice;
  final bool isCalculating;

  const ReceiversVehicle({
    super.key,
    required this.onVehicleSelected,
    required this.sendDataToFirestore,
    required this.onRequestSend,
    required this.noteController,
    required this.cashController,
    required this.calculatedTotalprice,
    required this.isCalculating,
  });

  @override
  State<ReceiversVehicle> createState() => _ReceiversVehicleState();
}

class _ReceiversVehicleState extends State<ReceiversVehicle> {
  bool _isDropDownVisible = false;
  String _selectedVehicleName = '';
  String _selectedVehiclePrice = '';
  String? email;

  final List<Map<String, String>> vehicleOptions = [
    {
      "name": "Bike",
      "price_per_km": "150",
      "imagePath": "lib/images/bike_image.png"
    },
    {
      "name": "Van",
      "price_per_km": "900",
      "imagePath": "lib/images/van_image.png"
    },
  ];
  bool _isDialogVisible = false;
  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  void _showLoadingDialog() {
    if (mounted) {
      _isDialogVisible = false; // clear it once dialog is dismissed
    }

    _isDialogVisible = true;
  }

  @override
  void didUpdateWidget(covariant ReceiversVehicle oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Show loading dialog if calculation just started
    if (widget.isCalculating && !oldWidget.isCalculating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showLoadingDialog();
        }
      });
    }

    // Hide loading dialog if calculation just ended
    if (!widget.isCalculating && oldWidget.isCalculating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isDialogVisible) {
          // Navigator.of(context, rootNavigator: true).pop(); // hide dialog
          _isDialogVisible = false;
        }
      });
    }
  }

  Future<void> _fetchUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() => email = userDoc['email']);
      }
    }
  }

  void _toggleDropdown() {
    setState(() => _isDropDownVisible = !_isDropDownVisible);
  }

  void _selectVehicle(String name, String price) {
    setState(() {
      _selectedVehicleName = name;
      _selectedVehiclePrice = price;
      _isDropDownVisible = false;
    });

    // This triggers distance/price calculation in the parent
    widget.onVehicleSelected(name, price);
  }

  // void _selectVehicle(String name, String price) {
  //   setState(() {
  //     _selectedVehicleName = name;
  //     _selectedVehiclePrice = price;
  //     _isDropDownVisible = false;
  //   });
  //   widget.onVehicleSelected(name, price);
  // }

  Future<bool> _checkUserBalance(double price) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      final rawBalance = doc['wallet_balance'] ?? 0;
      final walletBalance = (rawBalance is num) ? rawBalance.toDouble() : 0;
      return walletBalance >= price;
    } catch (e) {
      debugPrint("Error checking wallet balance: $e");
      return false;
    }
  }

  Future<bool> _debitUserWallet(double amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final docRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final currentBalance = (snapshot['wallet_balance'] ?? 0) as num;

        if (currentBalance >= amount) {
          transaction
              .update(docRef, {'wallet_balance': currentBalance - amount});
        } else {
          throw Exception('Insufficient balance');
        }
      });
      return true;
    } catch (e) {
      debugPrint('Error debiting wallet: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalFare = widget.calculatedTotalprice ?? 0.0;

    return Column(
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Image.asset("lib/images/bike.png",
                    height: 20, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedVehicleName.isEmpty
                        ? "Select vehicle category"
                        : "$_selectedVehicleName . ₦$_selectedVehiclePrice/km",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                Image.asset(
                  _isDropDownVisible
                      ? "lib/images/drop.png"
                      : "lib/images/drop2.png",
                  height: 20,
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
        if (_isDropDownVisible)
          Column(
            children: vehicleOptions.map((vehicle) {
              final isSelected = _selectedVehicleName == vehicle["name"];
              return GestureDetector(
                onTap: () =>
                    _selectVehicle(vehicle["name"]!, vehicle["price_per_km"]!),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected ? const Color(0xFF12AA6C) : Colors.white,
                      width: 0.5,
                    ),
                    color: isSelected ? Colors.white : Colors.grey.shade200,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vehicle["name"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                      ),
                      Text(
                        "₦${vehicle["price_per_km"]} per km",
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected
                              ? const Color(0xFF12AA6C)
                              : Colors.grey[600],
                        ),
                      ),
                      Image.asset(vehicle["imagePath"]!, height: 40),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 20),
        NoteWidget(controller: widget.noteController),
        const SizedBox(height: 20),
        CashWidget(controller: widget.cashController),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isCalculating
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF12AA6C),
                      ),
                    )
                  : Text(
                      "₦ ${NumberFormat("#,##0").format(totalFare)}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12AA6C),
                      ),
                    ),
              GestureDetector(
                onTap: () async {
                  if (_selectedVehicleName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a vehicle category.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final hasEnough = await _checkUserBalance(totalFare);
                  if (!hasEnough) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Insufficient balance.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final debited = await _debitUserWallet(totalFare);
                  if (!debited) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to debit wallet.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final success = await widget.sendDataToFirestore();
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to send request.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Dispatch Request Sent Successfully!✅',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.5,
                        ),
                      ),
                      backgroundColor: Color(0xFF12AA6C),
                    ),
                  );

                  widget.onRequestSend();
                },
                child: _isDialogVisible
                    ? const RequestButton(
                        text: "Request",
                        color: Color(0xFF12AA6C),
                        fontcolor: Colors.white,
                        border: Border(),
                        icon: Icons.arrow_forward_ios,
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
