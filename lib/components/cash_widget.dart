import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CashWidget extends StatefulWidget {
  final TextEditingController controller;
  const CashWidget({super.key, required this.controller});
  @override
  State<CashWidget> createState() => _CashWidgetState();
}

class _CashWidgetState extends State<CashWidget> {
  bool _isTextFieldVisible = true; // Controls visibility
  TextEditingController get controller => widget.controller;
  final NumberFormat _formatter = NumberFormat("#,##0", "en_US");
  final int _maxAmount = 100000; // ✅ Set Maximum Limit (₦100,000)

  void _onChanged(String value) {
    String cleanValue =
        value.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric
    if (cleanValue.isEmpty) {
      controller.clear();
      return;
    }

    int numericValue = int.parse(cleanValue);

    if (numericValue > _maxAmount) {
      numericValue = _maxAmount; // ✅ Restrict to max amount
    } // Convert cents to dollars
    String formattedValue = _formatter.format(numericValue);

    controller.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isTextFieldVisible = !_isTextFieldVisible; // Toggle visibility
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Image.asset(
                  "lib/images/cash.png",
                  height: 20,
                  color: _isTextFieldVisible ? Colors.grey : Colors.black,
                ), // Icon before text
                SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Receive cash for me . ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "NGN ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF12AA6C), // You can change the color
                        ),
                      ),
                      TextSpan(
                        text: controller
                            .text, // The amount entered in the text field
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF12AA6C), // You can change this color
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset(
                    _isTextFieldVisible
                        ? "lib/images/drop.png"
                        : "lib/images/drop2.png",
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        // Show TextField when _isTextFieldVisible is true
        if (_isTextFieldVisible)
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ], // Blocks non-numeric input
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "NGN 0.00",
              hintStyle: TextStyle(
                color: Color(0xFF12AA6C),
                fontWeight: FontWeight.bold,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF12AA6C), width: 0.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF12AA6C), width: 0.5)),
            ),
            onChanged: _onChanged,
          ),
      ],
    );
  }
}
