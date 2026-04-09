import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

/// A reusable [CustomPainter] that renders a [ui.FragmentShader].
///
/// The shader must have its uniforms already set before painting.
/// This painter simply draws a rect filled with the shader.
class ShaderPainter extends CustomPainter {
  /// Creates a painter that renders [shader].
  ///
  /// If [repaint] is provided, the painter repaints on each tick.
  ShaderPainter({
    required this.shader,
    super.repaint,
  });

  /// The fragment shader to render.
  final ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) => true;
}
