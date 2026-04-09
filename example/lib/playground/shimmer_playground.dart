import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class ShimmerPlayground extends StatefulWidget {
  const ShimmerPlayground({super.key});

  @override
  State<ShimmerPlayground> createState() => _ShimmerPlaygroundState();
}

class _ShimmerPlaygroundState extends State<ShimmerPlayground> {
  double _speed = 1.0;
  double _width = 0.3;
  double _angle = 0.5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Shimmer Effect',
      effect: Container(
        color: const Color(0xFF212121),
        child: ShimmerEffect(
          color: const Color(0xFFFFD700),
          speed: _speed,
          width: _width,
          angle: _angle,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 220,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 160,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 190,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'speed',
          value: _speed,
          min: 0.1,
          max: 3.0,
          onChanged: (v) => setState(() => _speed = v),
        ),
        ParamSlider(
          label: 'width',
          value: _width,
          min: 0.05,
          max: 1.0,
          onChanged: (v) => setState(() => _width = v),
        ),
        ParamSlider(
          label: 'angle',
          value: _angle,
          max: 1.571,
          onChanged: (v) => setState(() => _angle = v),
        ),
      ],
    );
  }
}
