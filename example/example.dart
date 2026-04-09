import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SnowEffect(
          density: 0.5,
          speed: 1.0,
          child: Center(
            child: GlassEffect(
              frost: 0.4,
              opacity: 0.3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'flutter_shaders_ui',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
