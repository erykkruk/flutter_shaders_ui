import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class WaterPlayground extends StatefulWidget {
  const WaterPlayground({super.key});

  @override
  State<WaterPlayground> createState() => _WaterPlaygroundState();
}

class _WaterPlaygroundState extends State<WaterPlayground> {
  double _speed = 1.0;
  double _depth = 0.5;
  double _waveIntensity = 0.5;
  double _causticIntensity = 0.6;
  double _foamAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Water Effect',
      effect: WaterEffect(
        color1: const Color(0xFF26C6DA),
        color2: const Color(0xFF0D47A1),
        speed: _speed,
        depth: _depth,
        waveIntensity: _waveIntensity,
        causticIntensity: _causticIntensity,
        foamAmount: _foamAmount,
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
          label: 'depth',
          value: _depth,
          onChanged: (v) => setState(() => _depth = v),
        ),
        ParamSlider(
          label: 'waveIntensity',
          value: _waveIntensity,
          onChanged: (v) => setState(() => _waveIntensity = v),
        ),
        ParamSlider(
          label: 'causticIntensity',
          value: _causticIntensity,
          onChanged: (v) => setState(() => _causticIntensity = v),
        ),
        ParamSlider(
          label: 'foamAmount',
          value: _foamAmount,
          onChanged: (v) => setState(() => _foamAmount = v),
        ),
      ],
    );
  }
}
