// import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:spatch_flutter/components/cash_widget.dart';
import 'package:spatch_flutter/components/note_widget.dart';
import 'package:spatch_flutter/components/request_button.dart';
import 'package:spatch_flutter/components/rushfleet_alert_dialog.dart';
import 'package:spatch_flutter/pages/home_page.dart';

class VehicleSelectionWidget extends StatefulWidget {
  final Future<bool> Function() sendDataToFirestore;
  final VoidCallback onRequestSend;
  final Function(String name, String pricePerKm) onVehicleSelected;
  final TextEditingController noteController;
  final TextEditingController cashController;
  final double? calculatedTotalprice;
  final double? calculatedDistanceKm;
  final bool isCalculating;

  const VehicleSelectionWidget({
    super.key,
    required this.sendDataToFirestore,
    required this.onRequestSend,
    required this.onVehicleSelected,
    required this.noteController,
    required this.cashController,
    required this.calculatedTotalprice,
    required this.calculatedDistanceKm,
    required this.isCalculating,
  });

  @override
  State<VehicleSelectionWidget> createState() => _VehicleSelectionWidgetState();
}

class _VehicleSelectionWidgetState extends State<VehicleSelectionWidget> {
  bool _isDropDownVisible = true;
  String _selectedVehicleName = '';
  String _selectedVehiclePrice = '';
  bool _isProcessing = false;
  bool _isDialogVisible = true;
  final List<Map<String, String>> vehicleOptions = [
    {
      "name": "Bike",
      "price_per_km": "210",
      "imagePath": "lib/images/bike_image.png"
    },
    {
      "name": "Van",
      "price_per_km": "600",
      "imagePath": "lib/images/van_image.png"
    },
  ];

  void _toggleDropdown() {
    setState(() => _isDropDownVisible = !_isDropDownVisible);
  }

  void _selectVehicle(String name, String price) {
    setState(() {
      _selectedVehicleName = name;
      _selectedVehiclePrice = price;
      _isDropDownVisible = false;
    });
    
    widget.onVehicleSelected(name, price);
  }

  Future<bool> _checkUserBalance(double price) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    final balance = (doc['wallet_balance'] ?? 0) as num;
    return balance >= price;
  }

  Future<bool> _debitUserWallet(double amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final ref = FirebaseFirestore.instance.collection('user').doc(user.uid);
    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(ref);
        final currentBalance = (snapshot['wallet_balance'] ?? 0) as num;
        if (currentBalance >= amount) {
          tx.update(ref, {'wallet_balance': currentBalance - amount});
        } else {
          throw Exception('Insufficient balance');
        }
      });
      return true;
    } catch (e) {
      debugPrint("Wallet debit error: $e");
      return false;
    }
  }

  Future<void> _handleRequest() async {
    if (_selectedVehicleName.isEmpty) {
      _showDialog('lib/images/delete.png', 'Please select a vehicle category');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final totalFare = widget.calculatedTotalprice ?? 0.0;

      // 1. Check if user has enough balance BEFORE sending data
      final hasEnough = await _checkUserBalance(totalFare);
      if (!hasEnough) {
        _showDialog('lib/images/delete.png', 'Insufficient wallet balance');
        setState(() => _isProcessing = false);
        return;
      }

      // 2. Then send data to Firestore
      final success = await widget.sendDataToFirestore();
      if (!success) throw Exception("Data submission failed");

      // 3. Then debit wallet
      final debited = await _debitUserWallet(totalFare);
      if (!debited) throw Exception("Wallet debit failed");

      // Optional: Reset form state
      setState(() {
        _selectedVehicleName = '';
        _selectedVehiclePrice = '';
      });

      
    } catch (e) {
      _showDialog(
          'lib/images/delete.png', 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showDialog(String image, String message, {bool redirectHome = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return RushFleetAlertDialog(
          title: image,
          message: message,
          confirmText: "Ok",
          onConfirm: () {
            Navigator.pop(context);
            if (redirectHome) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
                (route) => false,
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalFare = widget.calculatedTotalprice ?? 0.0;
    final distance = widget.calculatedDistanceKm ?? 0.0;

    return Column(
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Row(
              children: [
                Image.asset("lib/images/bike.png",
                    height: 20, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedVehicleName.isEmpty
                        ? "Select vehicle category"
                        : "$_selectedVehicleName · ₦$_selectedVehiclePrice/km",
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
        const SizedBox(height: 10),
        NoteWidget(controller: widget.noteController),
        const SizedBox(height: 10),
        CashWidget(controller: widget.cashController),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.isCalculating
                ? const CircularProgressIndicator(
                    strokeWidth: 3.5, color: Color(0xFF12AA6C))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Distance: ${NumberFormat("#,##0").format(distance)}Km",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF12AA6C),
                        ),
                      ),
                      Text(
                        "₦ ${NumberFormat("#,##0").format(totalFare)}",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12AA6C),
                        ),
                      ),
                    ],
                  ),
            Column(
              children: [
                _isProcessing
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                            strokeWidth: 3.5, color: Color(0xFF12AA6C)))
                    : GestureDetector(
                        onTap: _handleRequest,
                        child: const RequestButton(
                          text: "Request",
                          color: Color(0xFF12AA6C),
                          fontcolor: Colors.white,
                          border: Border(),
                          icon: Icons.arrow_forward_ios,
                        )),
              ],
            )
          ],
        ),
      ],
    );
  }
}
