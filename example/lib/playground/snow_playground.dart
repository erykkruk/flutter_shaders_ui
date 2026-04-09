import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class SnowPlayground extends StatefulWidget {
  const SnowPlayground({super.key});

  @override
  State<SnowPlayground> createState() => _SnowPlaygroundState();
}

class _SnowPlaygroundState extends State<SnowPlayground> {
  double _density = 0.5;
  double _speed = 1.0;
  double _size = 0.5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Snow Effect',
      effect: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFF1A237E)],
          ),
        ),
        child: SnowEffect(
          density: _density,
          speed: _speed,
          size: _size,
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'density',
          value: _density,
          onChanged: (v) => setState(() => _density = v),
        ),
        ParamSlider(
          label: 'speed',
          value: _speed,
          min: 0.1,
          max: 2.0,
          onChanged: (v) => setState(() => _speed = v),
        ),
        ParamSlider(
          label: 'size',
          value: _size,
          onChanged: (v) => setState(() => _size = v),
        ),
      ],
    );
  }
}
