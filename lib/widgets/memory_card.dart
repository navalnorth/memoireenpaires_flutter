import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final String imagePath;
  final bool isFlipped;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.imagePath,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isFlipped
          ? Image.asset(imagePath)
          : Container(
              color: Colors.deepPurple[800],
              child: Center(
                child: Icon(Icons.help_outline, color: Colors.white, size: 40),
              ),
            ),
    );
  }
}