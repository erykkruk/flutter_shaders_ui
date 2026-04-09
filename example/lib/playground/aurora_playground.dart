import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class AuroraPlayground extends StatefulWidget {
  const AuroraPlayground({super.key});

  @override
  State<AuroraPlayground> createState() => _AuroraPlaygroundState();
}

class _AuroraPlaygroundState extends State<AuroraPlayground> {
  double _intensity = 0.6;
  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Aurora Effect',
      effect: Container(
        color: const Color(0xFF0A0A0A),
        child: AuroraEffect(
          color1: const Color(0xFF00E676),
          color2: const Color(0xFF7C4DFF),
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
