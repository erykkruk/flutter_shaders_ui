#include <flutter/runtime_effect.glsl>

// --- Standard uniforms ---
uniform vec2 uResolution;    // index 0-1
uniform float uTime;         // index 2

// --- Custom uniforms ---
uniform vec4 uColor0;        // index 3-6   gradient stops (RGBA 0-1, straight alpha)
uniform vec4 uColor1;        // index 7-10
uniform vec4 uColor2;        // index 11-14
uniform vec4 uColor3;        // index 15-18
uniform float uColorCount;   // index 19, number of used stops (1-4)
uniform float uBorderWidth;  // index 20, ring thickness in logical px
uniform float uRadius;       // index 21, outer corner radius in logical px
uniform float uGlowSpread;   // index 22, space reserved outside the ring for glow
uniform float uGlow;         // index 23, glow strength 0-1
uniform float uPixel;        // index 24, one physical pixel in logical px

out vec4 fragColor;

const float TAU = 6.28318530718;

float roundedBoxDistance(vec2 p, vec2 halfSize, float radius) {
    vec2 q = abs(p) - halfSize + radius;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;
}

vec4 stop(float index) {
    if (index < 0.5) return uColor0;
    if (index < 1.5) return uColor1;
    if (index < 2.5) return uColor2;
    return uColor3;
}

// Cyclic gradient so the seam where the angle wraps is invisible.
vec4 gradientAt(float t) {
    float scaled = fract(t) * uColorCount;
    float index = floor(scaled);
    float next = mod(index + 1.0, uColorCount);
    float blend = smoothstep(0.0, 1.0, scaled - index);
    return mix(stop(index), stop(next), blend);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 p = fragCoord - uResolution * 0.5;

    vec2 halfSize = max(uResolution * 0.5 - uGlowSpread, vec2(0.0));
    float radius = min(uRadius, min(halfSize.x, halfSize.y));
    float d = roundedBoxDistance(p, halfSize, radius);

    // Coverage of the ring between the outer edge (d = 0) and the inner one.
    float aa = max(uPixel, 0.0001);
    float outer = clamp(0.5 - d / aa, 0.0, 1.0);
    float inner = clamp(0.5 + (d + uBorderWidth) / aa, 0.0, 1.0);
    float ring = outer * inner;

    float glow = 0.0;
    if (uGlowSpread > 0.0 && uGlow > 0.0) {
        float falloff = max(d, 0.0) / uGlowSpread;
        glow = uGlow * exp(-4.0 * falloff) * (1.0 - outer) * 0.8;
    }

    float angle = atan(p.y, p.x) / TAU;
    // One turn every 4 s; speed comes in through uTime (timeScale).
    vec4 color = gradientAt(angle + uTime * 0.25);

    float alpha = color.a * clamp(ring + glow, 0.0, 1.0);
    fragColor = vec4(color.rgb * alpha, alpha);
}
