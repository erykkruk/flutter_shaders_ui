#include <flutter/runtime_effect.glsl>

// --- Standard uniforms ---
uniform vec2 uResolution;    // index 0-1
uniform float uTime;         // index 2

// --- Custom uniforms ---
uniform float uSpeed;        // index 3, pulse speed multiplier
uniform float uIntensity;    // index 4, glow strength 0-1
uniform vec3 uColor;         // index 5-7, glow color (RGB 0-1)

out vec4 fragColor;

const float PI = 3.14159265359;
const float TAU = 6.28318530718;
const int RING_COUNT = 3;

// Soft noise for organic glow texture.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;

    // Center-relative coordinates with aspect correction
    float aspect = uResolution.x / uResolution.y;
    vec2 center = vec2(0.5 * aspect, 0.5);
    vec2 correctedUV = vec2(uv.x * aspect, uv.y);
    float dist = distance(correctedUV, center);

    float t = uTime * uSpeed;

    // --- Core breathing glow ---
    // Smooth breathing oscillation using combined sine waves
    float breath = sin(t * TAU * 0.25) * 0.5 + 0.5;
    // Add a secondary, slightly offset rhythm for organic feel
    float breath2 = sin(t * TAU * 0.18 + 1.2) * 0.5 + 0.5;
    float breathMix = breath * 0.7 + breath2 * 0.3;

    // Glow radius expands and contracts with the breath
    float minRadius = 0.15;
    float maxRadius = 0.55;
    float glowRadius = mix(minRadius, maxRadius, breathMix);

    // Soft gaussian-like falloff from center
    float coreGlow = exp(-dist * dist / (2.0 * glowRadius * glowRadius * 0.3));

    // --- Expanding pulse rings ---
    float rings = 0.0;
    for (int i = 0; i < RING_COUNT; i++) {
        float fi = float(i);
        // Each ring starts at a different phase offset
        float phase = t * 0.8 + fi * TAU / float(RING_COUNT);
        float ringProgress = fract(phase / TAU);

        // Ring expands outward from center
        float ringRadius = ringProgress * 0.7;

        // Ring shape: thin band at ringRadius distance from center
        float ringDist = abs(dist - ringRadius);
        float ringThickness = 0.02 + ringProgress * 0.015;
        float ring = smoothstep(ringThickness, 0.0, ringDist);

        // Fade out as ring expands
        float ringFade = 1.0 - ringProgress;
        ringFade = ringFade * ringFade;

        rings += ring * ringFade;
    }

    // --- Organic noise texture ---
    float noiseVal = noise(uv * 6.0 + t * 0.3);
    float noiseDetail = noise(uv * 15.0 - t * 0.5);
    float organicNoise = noiseVal * 0.7 + noiseDetail * 0.3;

    // Modulate the glow edge with noise for a non-perfect circle
    float noisyGlow = exp(-dist * dist / (2.0 * glowRadius * glowRadius * (0.25 + organicNoise * 0.15)));

    // --- Combine all elements ---
    float glow = 0.0;

    // Core glow (smooth, bright center)
    glow += coreGlow * 0.6;

    // Noisy glow (organic, textured edge)
    glow += noisyGlow * 0.3;

    // Pulse rings
    glow += rings * 0.5;

    // Apply intensity
    glow *= uIntensity;

    // Ensure center is brightest with a focused hot spot
    float hotspot = exp(-dist * dist / 0.01) * breathMix * 0.3;
    glow += hotspot * uIntensity;

    // Soft edge vignette to keep glow contained
    float edgeFade = 1.0 - smoothstep(0.3, 0.7, dist);
    glow *= 0.5 + edgeFade * 0.5;

    glow = clamp(glow, 0.0, 1.0);

    // Apply color
    vec3 color = uColor * glow;

    // Add subtle color shift at the edges (cooler/warmer)
    vec3 edgeColor = uColor * vec3(0.7, 0.85, 1.1);
    float colorShift = smoothstep(0.1, 0.5, dist);
    color = mix(color, edgeColor * glow, colorShift * 0.3);

    fragColor = vec4(color * glow, glow);
}
