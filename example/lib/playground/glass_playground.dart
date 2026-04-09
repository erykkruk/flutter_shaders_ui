import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class GlassPlayground extends StatefulWidget {
  const GlassPlayground({super.key});

  @override
  State<GlassPlayground> createState() => _GlassPlaygroundState();
}

class _GlassPlaygroundState extends State<GlassPlayground> {
  double _blurAmount = 0.5;
  double _frost = 0.4;
  double _opacity = 0.3;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Glass Effect',
      effect: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF880E4F)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: GlassEffect(
                blurAmount: _blurAmount,
                frost: _frost,
                opacity: _opacity,
                tint: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.blur_on, size: 64, color: Colors.white70),
                      SizedBox(height: 16),
                      Text(
                        'Frosted Glass',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'blur',
          value: _blurAmount,
          onChanged: (v) => setState(() => _blurAmount = v),
        ),
        ParamSlider(
          label: 'frost',
          value: _frost,
          onChanged: (v) => setState(() => _frost = v),
        ),
        ParamSlider(
          label: 'opacity',
          value: _opacity,
          onChanged: (v) => setState(() => _opacity = v),
        ),
      ],
    );
  }
}
