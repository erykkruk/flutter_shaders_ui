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
  /// A failed load is not cached: the next call tries the asset again.
  static Future<ui.FragmentProgram> load(String assetPath) {
    if (_cache.containsKey(assetPath)) {
      return Future.value(_cache[assetPath]!);
    }

    return _pending.putIfAbsent(assetPath, () async {
      try {
        final program = await ui.FragmentProgram.fromAsset(assetPath);
        _cache[assetPath] = program;
        return program;
      } finally {
        // Without this a failed load stayed pending forever, so every later
        // call got the same error back and the asset could never be retried.
        _pending.remove(assetPath);
      }
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
