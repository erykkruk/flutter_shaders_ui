import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class WavePlayground extends StatefulWidget {
  const WavePlayground({super.key});

  @override
  State<WavePlayground> createState() => _WavePlaygroundState();
}

class _WavePlaygroundState extends State<WavePlayground> {
  double _amplitude = 0.3;
  double _frequency = 2.0;
  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Wave Background',
      effect: WaveBackground(
        color1: const Color(0xFF1A237E),
        color2: const Color(0xFF00BCD4),
        amplitude: _amplitude,
        frequency: _frequency,
        speed: _speed,
      ),
      sliders: [
        ParamSlider(
          label: 'amplitude',
          value: _amplitude,
          onChanged: (v) => setState(() => _amplitude = v),
        ),
        ParamSlider(
          label: 'frequency',
          value: _frequency,
          max: 5.0,
          onChanged: (v) => setState(() => _frequency = v),
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
