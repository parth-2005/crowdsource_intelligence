import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class FeedbackPill extends StatefulWidget {
  final String actionType;
  final dynamic viewModel;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const FeedbackPill({
    super.key,
    required this.actionType,
    required this.viewModel,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<FeedbackPill> createState() => _FeedbackPillState();
}

class _FeedbackPillState extends State<FeedbackPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAction(String action) async {
    try {
      // Show loading state
      if (mounted) {
        setState(() {});
      }

      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        widget.onSuccess();
        // Auto-dismiss after success message
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        widget.onError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.flag_outlined,
                    label: 'Report',
                    action: 'report',
                    color: Colors.red[400]!,
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.share_outlined,
                    label: 'Share',
                    action: 'share',
                    color: Colors.blue[400]!,
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.thumb_up_outlined,
                    label: 'Helpful',
                    action: 'helpful',
                    color: Colors.green[400]!,
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.thumb_down_outlined,
                    label: 'Not Helpful',
                    action: 'unhelpful',
                    color: Colors.orange[400]!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String action,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleAction(action),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Icon(icon, size: 16, color: color),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
