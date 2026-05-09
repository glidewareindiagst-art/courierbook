import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const LoadingSkeletonWidget({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 8,
  });

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppTheme.outlineVariantLight,
                AppTheme.surfaceVariantLight,
                AppTheme.outlineVariantLight,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookingCardSkeletonWidget extends StatelessWidget {
  const BookingCardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A1565C0),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LoadingSkeletonWidget(
                height: 22,
                width: 60,
                borderRadius: 6,
              ),
              const Spacer(),
              const LoadingSkeletonWidget(
                height: 16,
                width: 16,
                borderRadius: 8,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const LoadingSkeletonWidget(height: 16, width: 160),
          const SizedBox(height: 6),
          const LoadingSkeletonWidget(height: 13, width: 120),
          const SizedBox(height: 10),
          Row(
            children: [
              const LoadingSkeletonWidget(height: 14, width: 80),
              const Spacer(),
              const LoadingSkeletonWidget(height: 14, width: 70),
            ],
          ),
        ],
      ),
    );
  }
}
