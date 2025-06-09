import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class Dialogexplicativa extends StatefulWidget {
  final String imageUrl; // Direct attribute
  final RichText explanation; // Direct attribute
  final VoidCallback onClose;

  const Dialogexplicativa({
    super.key,
    required this.imageUrl,
    required this.explanation,
    required this.onClose,
  });

  @override
  State<Dialogexplicativa> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<Dialogexplicativa>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();
  }

  void _closeDialog() {
    if (mounted) {
      Navigator.of(context).pop();
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    const double mobileWidthPercentage = 0.85;
    const double mobileHeightPercentage = 0.70;
    const double desktopMaxWidth = 500.0;
    const double desktopMaxHeight = 650.0;

    double desiredWidth = screenSize.width * mobileWidthPercentage;
    double desiredHeight = screenSize.height * mobileHeightPercentage;

    double finalDialogWidth = math.min(desiredWidth, desktopMaxWidth);
    finalDialogWidth = math.min(finalDialogWidth, screenSize.width * 0.95);

    double finalDialogHeight = math.min(desiredHeight, desktopMaxHeight);
    finalDialogHeight = math.min(finalDialogHeight, screenSize.height * 0.95);

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            width: finalDialogWidth,
            height: finalDialogHeight,
            child: _buildContent(finalDialogWidth, finalDialogHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double dialogWidth, double dialogHeight) {
    double baseFontSize = 16.0;
    double titleFontSize = 18.0;
    if (dialogWidth < 300) {
      baseFontSize = 13.0;
      titleFontSize = 15.0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                widget.imageUrl, // Accessing direct attribute
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: widget.explanation,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _closeDialog,
          child: const Text("Entendido"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
