import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:spatch_flutter/components/map_controller.dart';
import 'package:spatch_flutter/components/row_textfield.dart';
import 'package:spatch_flutter/components/rushfleet_alert_dialog.dart';
import 'package:spatch_flutter/components/vehicle_selection_widget.dart';

class ReceiverBookingContainer extends StatefulWidget {
  const ReceiverBookingContainer({super.key});

  @override
  State<ReceiverBookingContainer> createState() =>
      _ReceiverBookingContainerState();
}

class _ReceiverBookingContainerState extends State<ReceiverBookingContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _pickupController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _itemController = TextEditingController();
  final _noteController = TextEditingController();
  final _cashController = TextEditingController();
  Timer? _debounce;

  final String _orsApiKey = dotenv.env['ORS_KEY']!;

  String _selectedVehicleName = '';
  String _selectedVehiclePrice = '';
  double? _calculatedDistanceKm;
  double? _calculatedTotalPrice;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _pickupController.addListener(
      _triggerRecalculation,
    );
    _deliveryController.addListener(
      _triggerRecalculation,
    );
  }

  void _triggerRecalculation() {
    // Cancel any existing timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new 5-second timer
    _debounce = Timer(const Duration(seconds: 2), () {
      final pickup = _pickupController.text.trim();
      final delivery = _deliveryController.text.trim();

      if (_selectedVehiclePrice.isNotEmpty &&
          pickup.isNotEmpty &&
          delivery.isNotEmpty) {
        _calculateDistanceAndPrice();
      }
    });
  }

  Future<void> _calculateDistanceAndPrice() async {
    setState(() => _isCalculating = true);

    final pickup = _pickupController.text.trim();
    final delivery = _deliveryController.text.trim();

    final pickupCoords = await _getCoordinates(pickup);
    final deliveryCoords = await _getCoordinates(delivery);

    if (pickupCoords == null || deliveryCoords == null) {
      setState(() => _isCalculating = false);
      showDialog(
        context: context,
        builder: (context) {
          return RushFleetAlertDialog(
            title: 'lib/images/delete.png',
            message: 'Failed to get coordinates. Check address inputs',
            confirmText: "Ok",
            onConfirm: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return;
    }

    final distance = await _getDistanceInKm(pickupCoords, deliveryCoords);
    if (distance == null) {
      setState(() => _isCalculating = false);
      return;
    }

    final pricePerKm = double.tryParse(_selectedVehiclePrice) ?? 0;
    final totalPrice = pricePerKm * distance;

    setState(() {
      _calculatedDistanceKm = distance;
      _calculatedTotalPrice = totalPrice;
      _isCalculating = false;
    });
  }

  Future<Map<String, double>?> _getCoordinates(String address) async {
    final url = Uri.parse(
        'https://api.openrouteservice.org/geocode/search?api_key=$_orsApiKey&text=${Uri.encodeComponent(address)}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'];
      if (features != null && features.isNotEmpty) {
        final coords = features[0]['geometry']['coordinates'];
        return {'lat': coords[1], 'lng': coords[0]};
      }
    }
    return null;
  }

  Future<double?> _getDistanceInKm(
      Map<String, double> start, Map<String, double> end) async {
    final url =
        Uri.parse("https://api.openrouteservice.org/v2/directions/driving-car");
    final response = await http.post(
      url,
      headers: {
        'Authorization': _orsApiKey,
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "coordinates": [
          [start['lng'], start['lat']],
          [end['lng'], end['lat']]
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final distanceMeters = data['routes']?[0]?['summary']?['distance'];
      return (distanceMeters != null) ? distanceMeters / 1000 : null;
    }
    return null;
  }

  Future<bool> _submitDispatchRequest() async {
    if (!_formKey.currentState!.validate()) return false;

    if (_pickupController.text.trim().isEmpty ||
        _deliveryController.text.trim().isEmpty ||
        _contactNameController.text.trim().isEmpty ||
        _contactNumberController.text.trim().isEmpty ||
        _itemController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return RushFleetAlertDialog(
            title: 'lib/images/delete.png',
            message: 'All fields are required',
            confirmText: "Ok",
            onConfirm: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return false;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF12AA6C)),
      ),
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final pickup = _pickupController.text.trim();
      final delivery = _deliveryController.text.trim();
      final pickupCoords = await _getCoordinates(pickup);
      final deliveryCoords = await _getCoordinates(delivery);
      final distanceKm = await _getDistanceInKm(pickupCoords!, deliveryCoords!);

      final pricePerKm = double.tryParse(_selectedVehiclePrice) ?? 0;
      final totalPrice = pricePerKm * distanceKm!;

      final orderId = _generateOrderId();

      await FirebaseFirestore.instance.collection('dispatch_requests').add({
        'customer_id': user.uid,
        'email': user.email,
        'status': 'Pending',
        'payment_status': 'Pending',
        'order_id': orderId,
        'pick_up_address': pickup,
        'delivery_address': delivery,
        'selected_vehicle': _selectedVehicleName,
        'price_per_km': pricePerKm,
        'distance_km': distanceKm.toStringAsFixed(2),
        'total_price': totalPrice.toStringAsFixed(2),
        'contact_name': _contactNameController.text.trim(),
        'contact_number': _contactNumberController.text.trim(),
        'item_description': _itemController.text.trim(),
        'note': _noteController.text.trim(),
        'cash': _cashController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'rider_id': null,
      });

      Navigator.pop(context);
      // Clear all text fields after successful submission
      _pickupController.clear();
      _deliveryController.clear();
      _contactNameController.clear();
      _contactNumberController.clear();
      _itemController.clear();
      _noteController.clear();
      _cashController.clear();

      setState(() {
        _selectedVehicleName = "";
        _selectedVehiclePrice = "";
        _calculatedTotalPrice = 0.0;
      });
      return true;
    } catch (e) {
      print("Submission Error: $e");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return RushFleetAlertDialog(
            title: 'lib/images/delete.png',
            message: 'Failed to submit request',
            confirmText: "Ok",
            onConfirm: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return false;
    }
  }

  String _generateOrderId() {
    final rand = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final randomLetters =
        List.generate(4, (_) => letters[rand.nextInt(letters.length)]).join();
    final randomNumbers = (100 + rand.nextInt(900)).toString();
    return '#$randomNumbers$randomLetters';
  }

  Widget _buildAddressInput({
    required String iconPath,
    required TextEditingController controller,
    required String hintText,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Image.asset(iconPath, height: 30, color: iconColor),
        ),
        Expanded(
          child: MapController(hintText: hintText, controller: controller),
        ),
        GestureDetector(
          onTap: controller.clear,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset("lib/images/cancle_icon.png", height: 10),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: _buildAddressInput(
              iconPath: "lib/images/up-arrow.png",
              controller: _pickupController,
              hintText: "Pick up address",
              iconColor: const Color(0xFF12AA6C),
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      _buildAddressInput(
                        iconPath: "lib/images/downloadrf.png",
                        controller: _deliveryController,
                        hintText: "Where are we delivering to?",
                        iconColor: const Color(0xffFF9E00),
                      ),
                      RowTextfield(
                        controller: _contactNameController,
                        text: "Contact name",
                        iconColor: const Color(0xFF12AA6C),
                        imagePath: "lib/images/userrf.png",
                        iconPath: "lib/images/cancle_icon.png",
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),
                      RowTextfield(
                        controller: _contactNumberController,
                        text: "Contact number",
                        iconColor: const Color(0xFF12AA6C),
                        imagePath: "lib/images/roundrf.png",
                        iconPath: "lib/images/cancle_icon.png",
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),
                      RowTextfield(
                        controller: _itemController,
                        text: "Item",
                        iconColor: const Color(0xFF12AA6C),
                        imagePath: "lib/images/boxrf.png",
                        iconPath: "lib/images/cancle_icon.png",
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                VehicleSelectionWidget(
                  calculatedTotalprice: _calculatedTotalPrice,
                  calculatedDistanceKm: _calculatedDistanceKm,
                  cashController: _cashController,
                  noteController: _noteController,
                  isCalculating: _isCalculating,
                  onVehicleSelected: (name, price) {
                    setState(() {
                      _selectedVehicleName = name;
                      _selectedVehiclePrice = price;
                    });
                    _triggerRecalculation();
                  },
                  sendDataToFirestore: _submitDispatchRequest,
                  onRequestSend: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
