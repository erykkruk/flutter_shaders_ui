#include <flutter/runtime_effect.glsl>

// Standard uniforms
uniform vec2 uResolution;   // 0-1
uniform float uTime;        // 2

// Custom uniforms
uniform vec2 uPosition;     // 3-4  normalized center (0-1)
uniform float uRadius;      // 5    orb radius (0-1)
uniform float uGlowIntensity; // 6  glow multiplier
uniform vec3 uColor;        // 7-9  RGB (0-1)
uniform float uPulseSpeed;  // 10   breathing speed

out vec4 fragColor;

/// Attempt a soft 3D volumetric look by layering concentric
/// luminance shells with exponential falloff, a Fresnel-like rim,
/// and a subtle internal noise pattern for "living light" feel.

// --- helpers -----------------------------------------------------------------

// Simple hash for cheap noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Value noise (smooth)
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // smoothstep

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal Brownian Motion (2 octaves for perf)
float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 3; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

// --- main --------------------------------------------------------------------

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    // Aspect-corrected UV so the orb stays circular
    float aspect = uResolution.x / uResolution.y;
    vec2 uv = fragCoord / uResolution;

    // Center-relative position in aspect-corrected space
    vec2 center = uPosition;
    vec2 diff = uv - center;
    diff.x *= aspect;

    float dist = length(diff);

    // Animated radius with breathing pulse
    float pulse = 1.0 + 0.06 * sin(uTime * uPulseSpeed);
    float r = uRadius * pulse;

    // Normalised distance (0 = center, 1 = edge)
    float d = dist / max(r, 0.001);

    // ---- core brightness (super-bright center, soft falloff) ----------------
    float core = exp(-d * d * 4.0);          // tight Gaussian core
    float glow = exp(-d * 1.8);              // wide exponential glow
    float halo = exp(-d * d * 0.8) * 0.35;   // even wider soft halo

    // Combine layers
    float brightness = core + glow * 0.6 + halo;
    brightness *= uGlowIntensity;

    // ---- volumetric / 3D shading -------------------------------------------
    // Fresnel-like rim brightening at the edges of the visible sphere
    float sphereD = clamp(d, 0.0, 1.0);
    float fresnel = pow(1.0 - sqrt(max(1.0 - sphereD * sphereD, 0.0)), 2.0);
    float rimLight = fresnel * 0.3 * smoothstep(1.5, 0.6, d);

    // ---- internal light variation (subtle noise caustics) -------------------
    vec2 noiseUV = diff * 3.0 + uTime * 0.15;
    float caustic = fbm(noiseUV * 4.0 + uTime * 0.3);
    float internalVariation = caustic * 0.2 * smoothstep(1.2, 0.0, d);

    // ---- secondary pulse shimmer -------------------------------------------
    float shimmer = 0.04 * sin(uTime * uPulseSpeed * 2.3 + d * 12.0)
                  * smoothstep(1.5, 0.2, d);

    // ---- colour -------------------------------------------------------------
    // Slightly shift hue toward white at the very center for a hot-core look
    vec3 hotCore = mix(uColor, vec3(1.0), smoothstep(0.3, 0.0, d) * 0.6);

    // Tint the outer glow slightly cooler / more saturated
    vec3 outerTint = uColor * 0.8;
    vec3 col = mix(outerTint, hotCore, smoothstep(1.0, 0.0, d));

    // Add rim and caustic tints
    col += rimLight * uColor;
    col += internalVariation * uColor;
    col += shimmer;

    // ---- final composite ----------------------------------------------------
    float alpha = clamp(brightness, 0.0, 1.0);
    col *= brightness;

    // Premultiplied alpha output for correct compositing
    fragColor = vec4(col * alpha, alpha);
}
