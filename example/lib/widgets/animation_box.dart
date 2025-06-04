import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationBox extends StatefulWidget {
  final double width;
  final double height;

  const AnimationBox({
    super.key,
    this.width = 100,
    this.height = 100,
  });

  @override
  State<AnimationBox> createState() => _AnimationBoxState();
}

class _AnimationBoxState extends State<AnimationBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // 创建动画控制器，设置动画时长为2秒，并设置为循环播放
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // 创建旋转动画，从0到2π（360度）
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_controller);

    // 创建缩放动画，在0.5到1.5之间变化
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 创建颜色动画，在红色和蓝色之间变化
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
