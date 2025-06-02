import 'package:flutter/material.dart';

class NoteWidget extends StatefulWidget {
  final TextEditingController controller;
  const NoteWidget({super.key, required this.controller});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool _isTextFieldVisible = true;
  TextEditingController get controller => widget.controller;
  void _toggleTextField() {
    setState(() {
      _isTextFieldVisible = !_isTextFieldVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggleTextField,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "lib/images/note.png",
                    height: 20,
                    color: _isTextFieldVisible ? Colors.grey : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: Text(
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        controller.text.isEmpty
                            ? "Leave a note"
                            : controller.text),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  const Spacer(),
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
          if (_isTextFieldVisible)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                autocorrect: false,
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Write a message',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color(0xFF12AA6C), width: 0.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color(0xFF12AA6C), width: 0.5)),
                ),
              ),
            )
        ]);
  }
}
