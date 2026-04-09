import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'playground/aurora_playground.dart';
import 'playground/fire_playground.dart';
import 'playground/glass_playground.dart';
import 'playground/glow_orb_playground.dart';
import 'playground/pulse_playground.dart';
import 'playground/ripple_playground.dart';
import 'playground/shimmer_playground.dart';
import 'playground/snow_playground.dart';
import 'playground/wave_playground.dart';
import 'showcase/showcase_app.dart';

void main() {
  runApp(const ShaderGalleryApp());
}

class ShaderGalleryApp extends StatelessWidget {
  const ShaderGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shader Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const LauncherScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Launcher — choose between Gallery and Showcase
// ---------------------------------------------------------------------------

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        color1: const Color(0xFF0B0E1A),
        color2: const Color(0xFF131B2E),
        amplitude: 0.2,
        speed: 0.5,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerEffect(
                    color: Colors.white,
                    speed: 0.7,
                    width: 0.15,
                    child: const Text(
                      'flutter_shaders_ui',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose a demo mode',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 48),
                  _LauncherCard(
                    icon: Icons.grid_view_rounded,
                    title: 'Shader Gallery',
                    subtitle: 'Individual effect demos with controls',
                    color: const Color(0xFF6366F1),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _GalleryWrapper(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LauncherCard(
                    icon: Icons.phone_android_rounded,
                    title: 'App Showcase',
                    subtitle: 'Shaders in a real-world app UI',
                    color: const Color(0xFF10B981),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShowcaseApp()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LauncherCard extends StatelessWidget {
  const _LauncherCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: RippleEffect(
        color: color,
        intensity: 0.8,
        duration: const Duration(milliseconds: 700),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: color.withValues(alpha: 0.15),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white24,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wrapper to keep gallery code in the same file
class _GalleryWrapper extends StatelessWidget {
  const _GalleryWrapper();

  @override
  Widget build(BuildContext context) {
    return const GalleryHomeScreen();
  }
}

// ---------------------------------------------------------------------------
// Home Screen — grid of shader-powered buttons
// ---------------------------------------------------------------------------

class GalleryHomeScreen extends StatelessWidget {
  const GalleryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        color1: const Color(0xFF0D1B2A),
        color2: const Color(0xFF1B263B),
        amplitude: 0.2,
        speed: 0.6,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              ShimmerEffect(
                color: Colors.white,
                speed: 0.8,
                width: 0.15,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Shader Gallery',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap a card to explore',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: _cards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get _cards => const [
    _ShaderCard(
      title: 'Snow',
      icon: Icons.ac_unit,
      gradient: [Color(0xFF1A237E), Color(0xFF4FC3F7)],
      destination: SnowPlayground(),
    ),
    _ShaderCard(
      title: 'Aurora',
      icon: Icons.auto_awesome,
      gradient: [Color(0xFF1B5E20), Color(0xFF7C4DFF)],
      destination: AuroraPlayground(),
    ),
    _ShaderCard(
      title: 'Fire',
      icon: Icons.local_fire_department,
      gradient: [Color(0xFFBF360C), Color(0xFFFFAB00)],
      destination: FirePlayground(),
    ),
    _ShaderCard(
      title: 'Glass',
      icon: Icons.blur_on,
      gradient: [Color(0xFF37474F), Color(0xFF78909C)],
      destination: GlassPlayground(),
    ),
    _ShaderCard(
      title: 'Wave',
      icon: Icons.waves,
      gradient: [Color(0xFF0D47A1), Color(0xFF00BCD4)],
      destination: WavePlayground(),
    ),
    _ShaderCard(
      title: 'Shimmer',
      icon: Icons.flash_on,
      gradient: [Color(0xFF424242), Color(0xFFFFD700)],
      destination: ShimmerPlayground(),
    ),
    _ShaderCard(
      title: 'Pulse',
      icon: Icons.favorite,
      gradient: [Color(0xFF4A148C), Color(0xFFE040FB)],
      destination: PulsePlayground(),
    ),
    _ShaderCard(
      title: 'Glow Orb',
      icon: Icons.circle,
      gradient: [Color(0xFF0D1117), Color(0xFF00E5FF)],
      destination: GlowOrbPlayground(),
    ),
    _ShaderCard(
      title: 'Ripple',
      icon: Icons.touch_app,
      gradient: [Color(0xFF263238), Color(0xFF80CBC4)],
      destination: RipplePlayground(),
    ),
  ];
}

// ---------------------------------------------------------------------------
// Shader-styled button card
// ---------------------------------------------------------------------------

class _ShaderCard extends StatelessWidget {
  const _ShaderCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.destination,
  });

  final String title;
  final IconData icon;
  final List<Color> gradient;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, _ShaderPageRoute(page: destination)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PulseEffect(
          color: gradient.last.withValues(alpha: 0.4),
          speed: 0.6,
          intensity: 0.3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom page route with shader transition
// ---------------------------------------------------------------------------

class _ShaderPageRoute extends PageRouteBuilder {
  _ShaderPageRoute({required Widget page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: Tween(begin: 0.3, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      );
}

