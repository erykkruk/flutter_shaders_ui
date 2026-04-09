import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class RipplePlayground extends StatefulWidget {
  const RipplePlayground({super.key});

  @override
  State<RipplePlayground> createState() => _RipplePlaygroundState();
}

class _RipplePlaygroundState extends State<RipplePlayground> {
  double _intensity = 1.0;
  double _durationMs = 800;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Ripple Effect — Tap it!',
      effect: RippleEffect(
        color: const Color(0xFF80CBC4),
        intensity: _intensity,
        duration: Duration(milliseconds: _durationMs.round()),
        child: Container(
          color: const Color(0xFF263238),
          child: const Center(
            child: Icon(Icons.touch_app, size: 80, color: Colors.white30),
          ),
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'intensity',
          value: _intensity,
          max: 2.0,
          onChanged: (v) => setState(() => _intensity = v),
        ),
        ParamSlider(
          label: 'duration',
          value: _durationMs,
          min: 200,
          max: 2000,
          onChanged: (v) => setState(() => _durationMs = v),
        ),
      ],
    );
  }
}
