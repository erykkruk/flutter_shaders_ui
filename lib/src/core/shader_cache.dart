import 'dart:ui' as ui;

/// Global cache for loaded [ui.FragmentProgram] instances.
///
/// Prevents recompilation of shaders by caching them by asset path.
/// Thread-safe for single-isolate Flutter usage.
///
/// ```dart
/// final program = await ShaderCache.load('shaders/snow.frag');
/// final shader = program.fragmentShader();
/// ```
class ShaderCache {
  ShaderCache._();

  static final Map<String, ui.FragmentProgram> _cache = {};
  static final Map<String, Future<ui.FragmentProgram>> _pending = {};

  /// Loads a [ui.FragmentProgram] from the given [assetPath], using cache.
  ///
  /// If the shader is already loaded, returns the cached instance.
  /// If currently loading, awaits the same future (deduplication).
  static Future<ui.FragmentProgram> load(String assetPath) {
    if (_cache.containsKey(assetPath)) {
      return Future.value(_cache[assetPath]!);
    }

    return _pending.putIfAbsent(assetPath, () async {
      final program = await ui.FragmentProgram.fromAsset(assetPath);
      _cache[assetPath] = program;
      _pending.remove(assetPath);
      return program;
    });
  }

  /// Evicts a specific shader from the cache.
  static void evict(String assetPath) {
    _cache.remove(assetPath);
  }

  /// Clears all cached shaders.
  static void clearAll() {
    _cache.clear();
    _pending.clear();
  }
}
