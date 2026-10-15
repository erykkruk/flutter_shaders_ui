import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

/// One full orbit of the background blobs.
const Duration _orbitDuration = Duration(seconds: 6);

class FrostedPlayground extends StatefulWidget {
  const FrostedPlayground({super.key});

  @override
  State<FrostedPlayground> createState() => _FrostedPlaygroundState();
}

class _FrostedPlaygroundState extends State<FrostedPlayground>
    with SingleTickerProviderStateMixin {
  double _blur = 16;
  double _frost = 0.25;
  double _tintAlpha = 0.25;
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(vsync: this, duration: _orbitDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tint = Colors.white.withValues(alpha: _tintAlpha);

    return PlaygroundShell(
      title: 'Frosted Surface',
      effect: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF0F172A)),
          AnimatedBuilder(
            animation: _orbit,
            builder: (context, _) => _Blobs(progress: _orbit.value),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 104,
            child: FrostedSurface(
              blurSigma: _blur,
              frost: _frost,
              tint: tint,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Row(
                children: [
                  Icon(Icons.menu, color: Colors.white),
                  SizedBox(width: 16),
                  Text(
                    'Inbox',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: FrostedSurface(
                blurSigma: _blur,
                frost: _frost,
                tint: tint,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                padding: const EdgeInsets.all(24),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly summary',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$4,280.50',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '+12.4% vs last month',
                      style: TextStyle(color: Color(0xFFA7F3D0)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: FrostedSurface(
              blurSigma: _blur,
              frost: _frost,
              tint: tint,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home_rounded, color: Colors.white),
                  Icon(Icons.bar_chart_rounded, color: Colors.white60),
                  Icon(Icons.person_rounded, color: Colors.white60),
                ],
              ),
            ),
          ),
        ],
      ),
      sliders: [
        ParamSlider(
          label: 'blur',
          value: _blur,
          max: 30,
          onChanged: (v) => setState(() => _blur = v),
        ),
        ParamSlider(
          label: 'frost',
          value: _frost,
          onChanged: (v) => setState(() => _frost = v),
        ),
        ParamSlider(
          label: 'tint',
          value: _tintAlpha,
          max: 0.8,
          onChanged: (v) => setState(() => _tintAlpha = v),
        ),
      ],
    );
  }
}

class _Blobs extends StatelessWidget {
  const _Blobs({required this.progress});

  final double progress;

  static const _colors = [
    Color(0xFFF472B6),
    Color(0xFF06B6D4),
    Color(0xFFF59E0B),
    Color(0xFF7C3AED),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Stack(
          children: [
            for (var i = 0; i < _colors.length; i++) _blob(size, i, _colors[i]),
          ],
        );
      },
    );
  }

  Widget _blob(Size size, int index, Color color) {
    final phase = (progress + index / _colors.length) * 2 * math.pi;
    final diameter = size.shortestSide * 0.55;
    final cx = size.width / 2 + math.cos(phase) * size.width * 0.28;
    final cy = size.height / 2 + math.sin(phase * 1.3) * size.height * 0.3;
    return Positioned(
      left: cx - diameter / 2,
      top: cy - diameter / 2,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
