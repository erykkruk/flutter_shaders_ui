import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class PulsePlayground extends StatefulWidget {
  const PulsePlayground({super.key});

  @override
  State<PulsePlayground> createState() => _PulsePlaygroundState();
}

class _PulsePlaygroundState extends State<PulsePlayground> {
  double _speed = 1.0;
  double _intensity = 0.5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Pulse Effect',
      effect: Container(
        color: const Color(0xFF1A1A2E),
        child: PulseEffect(
          color: const Color(0xFFE040FB),
          speed: _speed,
          intensity: _intensity,
          child: const Center(
            child: Icon(Icons.favorite, size: 80, color: Colors.white70),
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
          label: 'intensity',
          value: _intensity,
          onChanged: (v) => setState(() => _intensity = v),
        ),
      ],
    );
  }
}
