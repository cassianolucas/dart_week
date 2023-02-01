import 'package:flutter/material.dart';

class DeliveryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? heigth;

  const DeliveryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.heigth = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heigth,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
