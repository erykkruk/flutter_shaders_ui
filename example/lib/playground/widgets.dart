import 'package:flutter/material.dart';

/// Global performance overlay state shared across all playground screens.
final performanceOverlay = ValueNotifier<bool>(false);

class ParamSlider extends StatelessWidget {
  const ParamSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFF6366F1),
                inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                thumbColor: Colors.white,
                overlayColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaygroundShell extends StatelessWidget {
  const PlaygroundShell({
    required this.title,
    required this.effect,
    required this.sliders,
    super.key,
  });

  final String title;
  final Widget effect;
  final List<Widget> sliders;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: performanceOverlay,
      builder: (context, showOverlay, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: showOverlay,
          theme: ThemeData.dark(useMaterial3: true),
          home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(title),
              backgroundColor: Colors.black38,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    showOverlay ? Icons.speed : Icons.speed_outlined,
                    color: showOverlay
                        ? const Color(0xFF6366F1)
                        : Colors.white54,
                  ),
                  tooltip: 'Performance Overlay',
                  onPressed: () =>
                      performanceOverlay.value = !performanceOverlay.value,
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(child: effect),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: sliders,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
