import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class FirePlayground extends StatefulWidget {
  const FirePlayground({super.key});

  @override
  State<FirePlayground> createState() => _FirePlaygroundState();
}

class _FirePlaygroundState extends State<FirePlayground> {
  double _intensity = 0.6;
  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Fire Effect',
      effect: Container(
        color: const Color(0xFF1A0A00),
        child: FireEffect(
          intensity: _intensity,
          speed: _speed,
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'intensity',
          value: _intensity,
          onChanged: (v) => setState(() => _intensity = v),
        ),
        ParamSlider(
          label: 'speed',
          value: _speed,
          min: 0.1,
          max: 3.0,
          onChanged: (v) => setState(() => _speed = v),
        ),
      ],
    );
  }
}
