import 'package:flutter/material.dart';

class BookingTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator; // Update the type for validator
  const BookingTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
  });

  @override
  State<BookingTextfield> createState() => _BookingTextfieldState();
}

class _BookingTextfieldState extends State<BookingTextfield> {
  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator, // Use the validator
      textCapitalization: TextCapitalization.sentences,
      autocorrect: false,
      enableSuggestions: false,
      cursorHeight: 15,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.w600, 
          letterSpacing: 0,
        ),
        suffixIcon: suggestions.isNotEmpty 
            ? Icon(Icons.search)  // Example icon if suggestions are present
            : null,
      ),
    );
  }
}
