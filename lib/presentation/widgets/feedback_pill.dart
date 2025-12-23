import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPill extends StatefulWidget {
  final String text;
  final Color color;
  final bool isGold;

  const FeedbackPill({
    super.key,
    required this.text,
    required this.color,
    this.isGold = false,
  });

  @override
  State<FeedbackPill> createState() => _FeedbackPillState();
}

class _FeedbackPillState extends State<FeedbackPill> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isGold ? const Color(0xFFFFD700) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: widget.isGold ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isGold ? Icons.star : Icons.check_circle, 
              size: 18, 
              color: widget.isGold ? Colors.black : widget.color
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: GoogleFonts.poppins(
                color: widget.isGold ? Colors.black : widget.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
