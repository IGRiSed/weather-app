import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
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
      builder: (context, _) {
        return Column(
          children: [
            _skeletonBox(height: 220, radius: 28),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: List.generate(
                6,
                (_) => _skeletonBox(height: double.infinity, radius: 16),
              ),
            ),
            const SizedBox(height: 16),
            _skeletonBox(height: 100, radius: 20),
          ],
        );
      },
    );
  }

  Widget _skeletonBox({required double height, required double radius}) {
    return Container(
      height: height == double.infinity ? null : height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(_animation.value),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
