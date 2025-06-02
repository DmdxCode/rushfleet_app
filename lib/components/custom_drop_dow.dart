import 'package:flutter/material.dart';

class CustomDropdownItem<T> extends StatefulWidget {
  final List<T> items;
  final String hintText;
  final Widget Function(T) itemBuilder;
  final Function(T) onItemSelected;
  void Function()? onTap;

  CustomDropdownItem({
    Key? key,
    required this.items,
    required this.onItemSelected,
    required this.itemBuilder,
    this.hintText = "",
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomDropdownItem<T>> createState() => _CustomDropdownItemState<T>();
}

class _CustomDropdownItemState<T> extends State<CustomDropdownItem<T>> {
  T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: DropdownButton<T>(
            menuWidth: 300,
            hint: Text(""),
            value: selectedItem,
            dropdownColor: Colors.white,
            elevation: 5, //
            borderRadius: BorderRadius.circular(10),
            icon: Image.asset("lib/images/drop.png"),
            items: widget.items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: widget.itemBuilder(item),
              );
            }).toList(),

            onChanged: (T? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedItem = newValue;
                });
                widget.onItemSelected(newValue);
              }
            },
          ),
        ),
      ],
    );
  }
}
