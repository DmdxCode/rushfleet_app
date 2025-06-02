import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapController extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  MapController({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  State<MapController> createState() => _MapControllerState();
}

class _MapControllerState extends State<MapController> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _insertOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _insertOverlay() {
    _overlayEntry ??= _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onItemSelected(dynamic item) {
    widget.controller.text = item['display_name'];
    _searchResults.clear();
    _removeOverlay();
    setState(() {});
  }

  void _searchLocation(String input) async {
    if (input.length < 3) {
      setState(() => _searchResults.clear());
      return;
    }

    setState(() => _isLoading = true);

    final url =
        'https://nominatim.openstreetmap.org/search?q=$input&format=json&addressdetails=1&limit=5&countrycodes=ng';
    final response = await http.get(Uri.parse(url),
        headers: {'User-Agent': 'FlutterApp (youremail@example.com)'});

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _searchResults = data;
        _isLoading = false;
        _overlayEntry?.markNeedsBuild(); // Refresh overlay with new data
      });
    } else {
      setState(() {
        _searchResults.clear();
        _isLoading = false;
      });
    }
  }

  OverlayEntry _buildOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            elevation: 1.7,
            child: _isLoading
                ? const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      return ListTile(
                        title: Text(
                          item['display_name'],
                          style: TextStyle(fontSize: 13),
                        ),
                        onTap: () => _onItemSelected(item),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        cursorHeight: 15,
        autocorrect: false,
        enableSuggestions: false,
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: _searchLocation,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }
}
