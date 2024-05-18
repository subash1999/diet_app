import 'package:flutter/material.dart';

class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final List<Color> gradientColors;

  const GradientFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          shape: BoxShape.circle,
        ),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 56.0,
            minHeight: 56.0,
          ),
          alignment: Alignment.center,
          child: icon,
        ),
      ), // Hide the default background
    );
  }
}
