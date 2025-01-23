import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;
  final bool showBackButton;
  final bool showSearchButton;
  final ValueChanged<String>? onSearchQueryChanged;

  const CustomAppBar({
    Key? key,
    this.onBackPressed,
    this.onSearchPressed,
    this.showBackButton = true,
    this.showSearchButton = true,
    this.onSearchQueryChanged,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _showSearchField = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Color(0xFF2D3B48),
      ),
      child: Row(
        children: [
          if (widget.showBackButton)
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 36,
              ),
              onPressed: widget.onBackPressed,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 48),

          if (!_showSearchField) const Expanded(child: SizedBox()),

          if (_showSearchField)
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: widget.onSearchQueryChanged,
              ),
            ),

          if (widget.showSearchButton)
            IconButton(
              icon: Icon(
                _showSearchField ? Icons.close : Icons.search,
                color: Colors.white,
                size: 31,
              ),
              onPressed: () {
                setState(() {
                  _showSearchField = !_showSearchField;
                });
                if (widget.onSearchPressed != null) {
                  widget.onSearchPressed!();
                }
              },
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
