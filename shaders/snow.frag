#include <flutter/runtime_effect.glsl>

// --- Standard uniforms ---
uniform vec2 uResolution;   // index 0-1
uniform float uTime;         // index 2

// --- Custom uniforms ---
uniform float uDensity;      // index 3, 0.0 - 1.0
uniform float uSpeed;        // index 4, 0.0 - 2.0
uniform float uSize;         // index 5, 0.0 - 1.0

out vec4 fragColor;

// --- Hash / noise utilities ---

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float hash2(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 hash2v(vec2 p) {
    return vec2(
        fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453),
        fract(sin(dot(p, vec2(269.5, 183.3))) * 43758.5453)
    );
}

// Smooth noise for wind
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = hash2(i);
    float b = hash2(i + vec2(1.0, 0.0));
    float c = hash2(i + vec2(0.0, 1.0));
    float d = hash2(i + vec2(1.0, 1.0));

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal brownian motion for organic wind patterns
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 3; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Soft circular snowflake shape with glow
float snowflake(vec2 uv, float radius) {
    float d = length(uv);
    // Core: sharp bright center
    float core = smoothstep(radius, radius * 0.2, d);
    // Glow: soft outer halo
    float glow = smoothstep(radius * 3.0, 0.0, d) * 0.3;
    return core + glow;
}

// Single snow layer with given parameters
float snowLayer(vec2 uv, float layerIndex, float time, float density, float speed, float size) {
    float result = 0.0;

    // Grid cell count derived from density and layer
    float cellCount = 8.0 + layerIndex * 6.0 + density * 12.0;

    // Scale UV to create grid
    vec2 scaledUv = uv * cellCount;

    // Apply falling motion
    float fallSpeed = (0.6 + layerIndex * 0.3) * speed;
    scaledUv.y += time * fallSpeed * cellCount * 0.15;

    // Gentle global wind
    float windPhase = time * 0.3 + layerIndex * 1.7;
    float globalWind = sin(windPhase) * 0.5;
    scaledUv.x += time * globalWind * 0.4;

    // Grid cell coordinates
    vec2 cell = floor(scaledUv);
    vec2 local = fract(scaledUv) - 0.5;

    // Check neighboring cells to avoid clipping at edges
    for (int yi = -1; yi <= 1; yi++) {
        for (int xi = -1; xi <= 1; xi++) {
            vec2 neighbor = vec2(float(xi), float(yi));
            vec2 cellId = cell + neighbor;

            // Random offset within cell for natural placement
            vec2 rnd = hash2v(cellId + layerIndex * 100.0);

            // Skip some cells based on density (more skipping = less snow)
            float threshold = 1.0 - density * 0.8;
            if (rnd.x < threshold) continue;

            // Random position offset within cell
            vec2 offset = (rnd - 0.5) * 0.6;

            // Per-particle local wind sway
            float swayPhase = time * (1.0 + rnd.y * 0.5) + rnd.x * 6.283;
            float sway = sin(swayPhase) * 0.08;
            offset.x += sway;

            // Turbulent micro-wind from fbm noise
            float turbulence = fbm(cellId * 0.5 + time * 0.1) - 0.5;
            offset.x += turbulence * 0.04;

            vec2 pos = neighbor + offset - local;

            // Randomized snowflake radius
            float baseRadius = 0.04 + rnd.y * 0.06;
            float radius = baseRadius * (0.5 + size);

            // Depth-based size: farther layers have smaller flakes
            float depthScale = 1.0 - layerIndex * 0.15;
            radius *= depthScale;

            float flake = snowflake(pos, radius);

            // Per-flake brightness variation
            float brightness = 0.7 + rnd.x * 0.3;
            result += flake * brightness;
        }
    }

    return result;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;

    // Aspect ratio correction for circular flakes
    float aspect = uResolution.x / uResolution.y;
    vec2 uvCorrected = vec2(uv.x * aspect, uv.y);

    float snow = 0.0;

    // Number of parallax layers (3-5 based on density)
    int layerCount = 3 + int(uDensity * 2.0);

    // Render each depth layer
    for (int i = 0; i < 5; i++) {
        if (i >= layerCount) break;

        float layerIdx = float(i);

        // Each layer has slightly different time offset for variety
        float layerTime = uTime + layerIdx * 17.3;

        // Parallax offset: farther layers move less
        float parallaxScale = 1.0 + layerIdx * 0.1;
        vec2 layerUv = uvCorrected * parallaxScale;

        float layer = snowLayer(layerUv, layerIdx, layerTime, uDensity, uSpeed, uSize);

        // Farther layers are dimmer (depth fog)
        float depthFade = 1.0 - layerIdx * 0.18;
        snow += layer * depthFade;
    }

    // Clamp and apply soft alpha
    snow = clamp(snow, 0.0, 1.0);

    // White snowflakes with computed alpha on transparent background
    fragColor = vec4(snow, snow, snow, snow);
}
