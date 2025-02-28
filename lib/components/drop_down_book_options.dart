import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/custom_drop_dow.dart';

class DropDownBookOptions extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelected;
  const DropDownBookOptions(
      {super.key, required this.items, required this.onItemSelected});

  @override
  State<DropDownBookOptions> createState() => _DropDownBookOptionsState();
}

class _DropDownBookOptionsState extends State<DropDownBookOptions> {
  String? selectedItem; // Holds the selected item

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            hint: Text("Select "),
            value: selectedItem,
            isExpanded: true,
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedItem = newValue;
              });
              widget.onItemSelected(newValue!);
            },
          ),
          SizedBox(height: 20),
          if (selectedItem != null)
            Text(
              "Selected: $selectedItem",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
