import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

// Shader programs cannot be compiled in the headless `flutter test`
// environment (no GPU / shader compiler), so these tests exercise the
// public widget contracts — default values, parameter storage and named
// constructors — rather than rendered output. This locks in the documented
// API of the published package and guards against accidental default drift.
void main() {
  group('ShaderEffectWidget', () {
    test('applies documented defaults', () {
      const widget = ShaderEffectWidget(assetPath: 'a.frag');

      expect(widget.assetPath, 'a.frag');
      expect(widget.child, isNull);
      expect(widget.uniformSetter, isNull);
      expect(widget.enabled, isTrue);
      expect(widget.showAsOverlay, isFalse);
      expect(widget.timeScale, 1.0);
    });

    test('stores custom values', () {
      const child = SizedBox();
      const widget = ShaderEffectWidget(
        assetPath: 'b.frag',
        enabled: false,
        showAsOverlay: true,
        timeScale: 2.5,
        child: child,
      );

      expect(widget.assetPath, 'b.frag');
      expect(widget.enabled, isFalse);
      expect(widget.showAsOverlay, isTrue);
      expect(widget.timeScale, 2.5);
      expect(widget.child, same(child));
    });

    test('timeScale supports freeze and reverse values', () {
      expect(
        const ShaderEffectWidget(assetPath: 'a', timeScale: 0).timeScale,
        0.0,
      );
      expect(
        const ShaderEffectWidget(assetPath: 'a', timeScale: -1).timeScale,
        -1.0,
      );
    });
  });

  group('AuroraEffect', () {
    test('defaults', () {
      const widget = AuroraEffect();

      expect(widget.color1, const Color(0xFF00E676));
      expect(widget.color2, const Color(0xFFAA00FF));
      expect(widget.intensity, 0.6);
      expect(widget.speed, 1.0);
      expect(widget.enabled, isTrue);
    });

    test('stores custom values', () {
      const widget = AuroraEffect(
        color1: Colors.red,
        color2: Colors.blue,
        intensity: 0.9,
        speed: 2.0,
        enabled: false,
      );

      expect(widget.color1, Colors.red);
      expect(widget.color2, Colors.blue);
      expect(widget.intensity, 0.9);
      expect(widget.speed, 2.0);
      expect(widget.enabled, isFalse);
    });
  });

  group('FireEffect', () {
    test('defaults', () {
      const widget = FireEffect();

      expect(widget.intensity, 0.6);
      expect(widget.speed, 1.0);
      expect(widget.color1, const Color(0xFFFFEB3B));
      expect(widget.color2, const Color(0xFFFF5722));
      expect(widget.enabled, isTrue);
    });
  });

  group('GlassEffect', () {
    test('defaults', () {
      const widget = GlassEffect();

      expect(widget.blurAmount, 0.5);
      expect(widget.frost, 0.4);
      expect(widget.opacity, 0.3);
      expect(widget.tint, const Color(0xFFFFFFFF));
      expect(widget.enabled, isTrue);
    });
  });

  group('GlowOrb', () {
    test('static constructor defaults', () {
      const widget = GlowOrb();

      expect(widget.position, const Offset(0.5, 0.5));
      expect(widget.color, Colors.cyan);
      expect(widget.radius, 0.15);
      expect(widget.glowIntensity, 1.0);
      expect(widget.pulseSpeed, 2.0);
      expect(widget.enabled, isTrue);
    });

    test('bouncing constructor uses its own color default', () {
      const widget = GlowOrb.bouncing();

      expect(widget.color, Colors.purple);
      expect(widget.position, const Offset(0.5, 0.5));
      expect(widget.radius, 0.15);
    });

    test('draggable constructor uses its own color default', () {
      const widget = GlowOrb.draggable();

      expect(widget.color, Colors.orange);
      expect(widget.position, const Offset(0.5, 0.5));
    });

    test('stores custom values', () {
      const widget = GlowOrb(
        position: Offset(0.2, 0.8),
        color: Colors.green,
        radius: 0.3,
        glowIntensity: 1.5,
        pulseSpeed: 4.0,
        enabled: false,
      );

      expect(widget.position, const Offset(0.2, 0.8));
      expect(widget.color, Colors.green);
      expect(widget.radius, 0.3);
      expect(widget.glowIntensity, 1.5);
      expect(widget.pulseSpeed, 4.0);
      expect(widget.enabled, isFalse);
    });
  });

  group('PulseEffect', () {
    test('defaults', () {
      const widget = PulseEffect();

      expect(widget.color, const Color(0xFF2196F3));
      expect(widget.speed, 1.0);
      expect(widget.intensity, 0.5);
      expect(widget.enabled, isTrue);
    });
  });

  group('RippleEffect', () {
    test('defaults with required child', () {
      const widget = RippleEffect(child: SizedBox());

      expect(widget.child, isA<SizedBox>());
      expect(widget.color, Colors.white);
      expect(widget.duration, const Duration(milliseconds: 800));
      expect(widget.intensity, 1.0);
      expect(widget.onTap, isNull);
    });
  });

  group('ShimmerEffect', () {
    test('defaults', () {
      const widget = ShimmerEffect();

      expect(widget.color, const Color(0x40FFFFFF));
      expect(widget.angle, 0.5);
      expect(widget.speed, 1.0);
      expect(widget.width, 0.3);
      expect(widget.enabled, isTrue);
    });
  });

  group('SnowEffect', () {
    test('defaults', () {
      const widget = SnowEffect();

      expect(widget.density, 0.5);
      expect(widget.speed, 1.0);
      expect(widget.size, 0.5);
      expect(widget.enabled, isTrue);
    });
  });

  group('WaterEffect', () {
    test('defaults', () {
      const widget = WaterEffect();

      expect(widget.color1, const Color(0xFF26C6DA));
      expect(widget.color2, const Color(0xFF0D47A1));
      expect(widget.speed, 1.0);
      expect(widget.depth, 0.5);
      expect(widget.waveIntensity, 0.5);
      expect(widget.causticIntensity, 0.6);
      expect(widget.foamAmount, 0.0);
      expect(widget.enabled, isTrue);
    });
  });

  group('WaveBackground', () {
    test('defaults', () {
      const widget = WaveBackground();

      expect(widget.color1, const Color(0xFF1A237E));
      expect(widget.color2, const Color(0xFF00BCD4));
      expect(widget.amplitude, 0.3);
      expect(widget.frequency, 2.0);
      expect(widget.speed, 1.0);
      expect(widget.enabled, isTrue);
    });
  });

  group('ShaderCache', () {
    test('evict and clearAll are safe on an empty cache', () {
      expect(() => ShaderCache.evict('missing.frag'), returnsNormally);
      expect(ShaderCache.clearAll, returnsNormally);
    });
  });
}
