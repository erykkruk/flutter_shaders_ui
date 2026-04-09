#include <flutter/runtime_effect.glsl>

// Standard uniforms
uniform vec2 uResolution;   // 0-1
uniform float uTime;        // 2

// Custom uniforms
uniform float uAmplitude;   // 3  wave height (0-1)
uniform float uFrequency;   // 4  wave density (0-5)
uniform float uSpeed;       // 5  animation speed
uniform vec3 uColor1;       // 6-8  primary color (RGB 0-1)
uniform vec3 uColor2;       // 9-11 secondary color (RGB 0-1)

out vec4 fragColor;

// Attempt organic motion via smooth noise approximation
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float smoothNoise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), u);
}

// Compute a single wave layer with phase offset and frequency variation
float waveLayer(float x, float t, float freq, float phase, float amp) {
    return amp * sin(x * freq + t + phase)
         + amp * 0.5 * sin(x * freq * 1.7 + t * 1.3 + phase * 0.7)
         + amp * 0.25 * sin(x * freq * 2.9 + t * 0.8 + phase * 1.4);
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord / uResolution;

    float t = uTime * uSpeed;

    // Normalized x position for wave calculation
    float x = uv.x;

    // Build multiple overlapping wave layers for organic depth
    float wave1 = waveLayer(x, t * 0.9, uFrequency * 3.0, 0.0, uAmplitude * 0.12);
    float wave2 = waveLayer(x, t * 0.7, uFrequency * 2.0, 1.5, uAmplitude * 0.18);
    float wave3 = waveLayer(x, t * 1.1, uFrequency * 4.5, 3.0, uAmplitude * 0.08);
    float wave4 = waveLayer(x, t * 0.5, uFrequency * 1.5, 4.7, uAmplitude * 0.15);
    float wave5 = waveLayer(x, t * 1.3, uFrequency * 5.5, 2.3, uAmplitude * 0.06);

    // Subtle noise-based horizontal drift for organic feel
    float drift = smoothNoise(uv.y * 3.0 + t * 0.4) * 0.03 * uAmplitude;

    // Combine all layers into a composite displacement
    float totalWave = wave1 + wave2 + wave3 + wave4 + wave5 + drift;

    // Vertical gradient factor shifted by waves
    float gradient = uv.y + totalWave;

    // Clamp and smooth the gradient for a fluid blending range
    gradient = smoothstep(0.0, 1.0, gradient);

    // Add subtle secondary undulation based on screen position
    float detail = sin(uv.x * uFrequency * 8.0 + t * 2.0) * 0.015 * uAmplitude;
    detail += sin(uv.y * uFrequency * 6.0 - t * 1.5) * 0.01 * uAmplitude;
    gradient = clamp(gradient + detail, 0.0, 1.0);

    // Smooth cubic interpolation for premium color blending
    float blend = gradient * gradient * (3.0 - 2.0 * gradient);

    // Mix primary and secondary colors
    vec3 color = mix(uColor1, uColor2, blend);

    // Add subtle luminance variation from wave peaks for depth
    float highlight = (wave1 + wave2) * 0.5 + 0.5;
    highlight = smoothstep(0.3, 0.7, highlight);
    color += vec3(highlight * 0.06);

    // Very subtle vignette for a polished feel
    vec2 center = uv - 0.5;
    float vignette = 1.0 - dot(center, center) * 0.3;
    color *= vignette;

    fragColor = vec4(color, 1.0);
}
