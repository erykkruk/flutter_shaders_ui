#include <flutter/runtime_effect.glsl>

// Standard uniforms
uniform vec2 uResolution;   // 0-1
uniform float uTime;        // 2

// Custom uniforms
uniform float uIntensity;   // 3  flame height / intensity (0-1)
uniform float uSpeed;       // 4  animation speed multiplier
uniform vec3 uColor1;       // 5-7  inner flame color (RGB 0-1)
uniform vec3 uColor2;       // 8-10 outer flame color (RGB 0-1)

out vec4 fragColor;

// --- Noise utilities ---

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float hash1(float n) {
    return fract(sin(n) * 43758.5453123);
}

// Smooth value noise
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

// Fractal Brownian Motion with 5 octaves for rich detail
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    mat2 rot = mat2(0.8, 0.6, -0.6, 0.8); // domain rotation for variety
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        p = rot * p;
        frequency *= 2.1;
        amplitude *= 0.5;
    }
    return value;
}

// Turbulence (absolute-value noise for sharp flame edges)
float turbulence(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    mat2 rot = mat2(0.8, 0.6, -0.6, 0.8);
    for (int i = 0; i < 6; i++) {
        value += amplitude * abs(noise(p * frequency) * 2.0 - 1.0);
        p = rot * p;
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Distorted noise for organic flame shapes
float flameNoise(vec2 p, float t) {
    // Primary upward flow
    vec2 flow = vec2(0.0, -t * 2.5);
    float n1 = fbm(p * 3.0 + flow);

    // Secondary turbulent flow at different speed
    vec2 flow2 = vec2(t * 0.3, -t * 3.2);
    float n2 = fbm(p * 5.0 + flow2 + 100.0);

    // Tertiary fine detail
    vec2 flow3 = vec2(-t * 0.5, -t * 4.0);
    float n3 = turbulence(p * 8.0 + flow3 + 200.0);

    return n1 * 0.5 + n2 * 0.3 + n3 * 0.2;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;

    float aspect = uResolution.x / uResolution.y;

    float t = uTime * uSpeed;

    // Work in aspect-corrected space
    vec2 p = uv;
    p.x *= aspect;

    // Center horizontally in corrected space
    float centerX = aspect * 0.5;

    // --- Flame shape mask ---
    // Flames rise from the bottom, so flip Y: 0 at bottom, 1 at top
    float y = 1.0 - uv.y;

    // Horizontal distance from center (normalized)
    float dx = abs(p.x - centerX) / (aspect * 0.5);

    // Flame envelope: wider at bottom, tapering upward
    // uIntensity controls how high the flames reach
    float flameHeight = 0.3 + uIntensity * 0.55;

    // Base flame shape: parabolic taper
    float taper = 1.0 - smoothstep(0.0, 0.5 + uIntensity * 0.3, dx);
    taper *= taper;

    // Vertical fade: strong at bottom, fading upward
    float verticalMask = smoothstep(flameHeight + 0.05, 0.0, y);
    verticalMask *= smoothstep(-0.02, 0.05, y); // soft bottom edge

    // Combined base shape
    float shape = taper * verticalMask;

    // --- Animated flame distortion ---
    // Use layered noise to distort the flame shape organically

    // Position for noise sampling, scaled for good-looking flames
    vec2 noisePos = vec2(uv.x * 2.0, y * 1.5);

    // Primary flame noise (large-scale licks)
    float n = flameNoise(noisePos, t);

    // Additional horizontal wavering
    float waver = sin(y * 8.0 + t * 3.0) * 0.03 * (1.0 - y);
    waver += sin(y * 15.0 + t * 5.0) * 0.015;

    // Distort the shape with noise
    float distortedShape = shape;

    // Noise pushes flame edges in/out for licking tongues of fire
    distortedShape *= (0.6 + n * 0.8);

    // Add horizontal waver to break symmetry
    float waverMask = smoothstep(0.0, 0.3, y) * smoothstep(flameHeight, 0.1, y);
    distortedShape += waver * waverMask * 0.5;

    // --- Flickering ---
    // Random brightness variation for natural fire flicker
    float flicker = 0.85 + 0.15 * sin(t * 7.0 + hash1(floor(t * 12.0)) * 6.28);
    flicker *= 0.9 + 0.1 * sin(t * 13.0 + 1.5);
    distortedShape *= flicker;

    // --- Hot core ---
    // Brighter core along the center axis, near the base
    float coreX = 1.0 - smoothstep(0.0, 0.25, dx);
    float coreY = smoothstep(0.4, 0.0, y);
    float core = coreX * coreY * 0.6;

    // --- Color gradient ---
    // Inner -> outer based on distance from hottest region
    // y-position: bottom is hotter (inner color), top is cooler (outer color)
    // x-position: center is hotter, edges are cooler
    float colorMix = smoothstep(0.0, flameHeight * 0.8, y);
    colorMix = max(colorMix, smoothstep(0.0, 0.4, dx));

    // Noise-driven color variation for organic look
    colorMix += (n - 0.5) * 0.3;
    colorMix = clamp(colorMix, 0.0, 1.0);

    // Cubic interpolation for smoother color transition
    colorMix = colorMix * colorMix * (3.0 - 2.0 * colorMix);

    vec3 flameColor = mix(uColor1, uColor2, colorMix);

    // Add hot white core at the very base center
    vec3 hotWhite = vec3(1.0, 0.95, 0.8);
    flameColor = mix(flameColor, hotWhite, core * distortedShape);

    // Boost brightness in the lower-center region
    float brightnessBoost = coreY * coreX * 0.3;
    flameColor += brightnessBoost * uColor1;

    // --- Ember sparks (small bright particles rising) ---
    float sparks = 0.0;
    for (int i = 0; i < 3; i++) {
        float fi = float(i);
        vec2 sparkUV = uv;

        // Each spark layer has different speed and offset
        float sparkTime = t * (1.5 + fi * 0.5) + fi * 7.13;
        sparkUV.y += sparkTime * 0.15;
        sparkUV.x += sin(sparkTime * 0.7 + fi * 3.0) * 0.05;

        // Grid for spark placement
        vec2 sparkCell = floor(sparkUV * (15.0 + fi * 8.0));
        vec2 sparkLocal = fract(sparkUV * (15.0 + fi * 8.0)) - 0.5;

        float rnd = hash(sparkCell + fi * 100.0);

        // Only some cells have sparks (sparse distribution)
        if (rnd > 0.92) {
            vec2 sparkOffset = vec2(hash(sparkCell + 10.0), hash(sparkCell + 20.0)) - 0.5;
            sparkOffset *= 0.4;
            float sparkDist = length(sparkLocal - sparkOffset);

            float sparkRadius = 0.03 + rnd * 0.02;
            float spark = smoothstep(sparkRadius, sparkRadius * 0.2, sparkDist);

            // Sparks only visible in the flame region and slightly above
            float sparkMask = smoothstep(flameHeight + 0.15, 0.0, 1.0 - uv.y);
            sparkMask *= smoothstep(0.0, 0.1, 1.0 - uv.y);

            // Sparks near center axis
            float sparkCenterMask = 1.0 - smoothstep(0.0, 0.4, dx);

            sparks += spark * sparkMask * sparkCenterMask * 0.4;
        }
    }

    // --- Final composite ---
    float alpha = clamp(distortedShape, 0.0, 1.0);

    // Add sparks to alpha
    alpha = clamp(alpha + sparks, 0.0, 1.0);

    vec3 finalColor = flameColor;

    // Sparks are bright inner-color
    finalColor = mix(finalColor, uColor1 + vec3(0.2), sparks * 2.0);

    // Clamp color values
    finalColor = clamp(finalColor, 0.0, 1.0);

    // Apply intensity to overall brightness
    finalColor *= 0.7 + uIntensity * 0.5;

    // Premultiplied alpha for correct compositing
    fragColor = vec4(finalColor * alpha, alpha);
}
