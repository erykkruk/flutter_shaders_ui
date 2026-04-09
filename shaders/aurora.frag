#include <flutter/runtime_effect.glsl>

// --- Standard uniforms ---
uniform vec2 uResolution;    // index 0-1
uniform float uTime;         // index 2

// --- Custom uniforms ---
uniform float uIntensity;    // index 3, 0.0 - 1.0
uniform float uSpeed;        // index 4, multiplier
uniform vec3 uColor1;        // index 5-7, primary aurora color
uniform vec3 uColor2;        // index 8-10, secondary aurora color

out vec4 fragColor;

const float PI = 3.14159265359;
const float TAU = 6.28318530718;
const int AURORA_LAYERS = 5;

// --- Noise utilities ---

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

// Fractal brownian motion for organic flowing shapes.
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Domain-warped fbm for extra organic distortion.
float warpedFbm(vec2 p, float t) {
    vec2 q = vec2(
        fbm(p + vec2(0.0, 0.0) + t * 0.15),
        fbm(p + vec2(5.2, 1.3) + t * 0.12)
    );
    vec2 r = vec2(
        fbm(p + 4.0 * q + vec2(1.7, 9.2) + t * 0.1),
        fbm(p + 4.0 * q + vec2(8.3, 2.8) + t * 0.08)
    );
    return fbm(p + 4.0 * r);
}

// Single aurora curtain band at a given vertical position.
float auroraBand(vec2 uv, float yCenter, float t, float seed) {
    // Horizontal flow via warped noise
    float warp = warpedFbm(
        vec2(uv.x * 1.5 + seed * 3.7, t * 0.2 + seed),
        t * 0.3
    );

    // Vertical displacement: the curtain ripples up and down
    float verticalWave = sin(uv.x * 3.0 + t * 0.7 + seed * TAU) * 0.06;
    verticalWave += sin(uv.x * 7.0 - t * 0.4 + seed * 5.0) * 0.03;
    verticalWave += (warp - 0.5) * 0.12;

    float y = uv.y - yCenter - verticalWave;

    // Band shape: soft gaussian-like falloff
    float bandWidth = 0.06 + warp * 0.04;
    float band = exp(-y * y / (2.0 * bandWidth * bandWidth));

    // Internal luminance variation (shimmering)
    float shimmer = fbm(vec2(uv.x * 8.0 + t * 0.5, uv.y * 4.0 + seed * 10.0));
    band *= 0.5 + shimmer * 0.7;

    // Feather the band downward (aurora curtains trail down)
    float curtainTrail = smoothstep(0.0, 0.15, y + 0.15) * exp(-max(y, 0.0) * 3.0);
    band += curtainTrail * 0.3 * shimmer;

    return band;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;

    float t = uTime * uSpeed;

    // Accumulate multiple aurora layers
    vec3 color = vec3(0.0);
    float totalAlpha = 0.0;

    for (int i = 0; i < AURORA_LAYERS; i++) {
        float fi = float(i);
        float seed = fi * 0.73 + 0.1;

        // Each layer sits at a different vertical position (upper portion)
        float yCenter = 0.3 + fi * 0.08 + sin(t * 0.1 + fi * 1.5) * 0.04;

        float band = auroraBand(uv, yCenter, t, seed);

        // Interpolate color between uColor1 and uColor2 per layer
        float colorMix = sin(fi * 1.2 + t * 0.15) * 0.5 + 0.5;
        // Add a third intermediate hue by blending toward a cyan-ish midpoint
        vec3 midColor = mix(uColor1, uColor2, 0.5) + vec3(0.0, 0.08, 0.05);
        vec3 layerColor;
        if (colorMix < 0.5) {
            layerColor = mix(uColor1, midColor, colorMix * 2.0);
        } else {
            layerColor = mix(midColor, uColor2, (colorMix - 0.5) * 2.0);
        }

        // Layer depth fading: later layers are slightly dimmer
        float depthFade = 1.0 - fi * 0.12;

        float layerAlpha = band * depthFade;
        color += layerColor * layerAlpha;
        totalAlpha += layerAlpha;
    }

    // Apply intensity
    color *= uIntensity;
    totalAlpha *= uIntensity;

    // Soft vertical fade: aurora is strongest at the top, fades toward bottom
    float verticalFade = smoothstep(1.0, 0.2, uv.y);
    color *= verticalFade;
    totalAlpha *= verticalFade;

    // Subtle glow bloom
    float bloom = totalAlpha * 0.15;
    color += mix(uColor1, uColor2, 0.5) * bloom;

    totalAlpha = clamp(totalAlpha, 0.0, 1.0);

    fragColor = vec4(color * totalAlpha, totalAlpha);
}
