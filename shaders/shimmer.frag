#include <flutter/runtime_effect.glsl>

// --- Standard uniforms ---
uniform vec2 uResolution;    // index 0-1
uniform float uTime;         // index 2

// --- Custom uniforms ---
uniform float uAngle;        // index 3, sweep angle in radians
uniform float uSpeed;        // index 4, animation speed multiplier
uniform vec3 uColor;         // index 5-7, shimmer highlight color (RGB 0-1)
uniform float uWidth;        // index 8, shimmer band width 0-1

out vec4 fragColor;

const float PI = 3.14159265359;

// Soft noise for subtle texture within the shimmer band.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
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

    // Direction vector from angle
    vec2 dir = vec2(cos(uAngle), sin(uAngle));

    // Project UV onto the sweep direction
    float projection = dot(uv - 0.5, dir) + 0.5;

    // Animate the sweep position: loops from -bandwidth to 1+bandwidth
    float totalRange = 1.0 + uWidth * 2.0;
    float sweep = mod(uTime * uSpeed * 0.4, totalRange) - uWidth;

    // Distance from the current sweep center
    float dist = projection - sweep;

    // Shimmer band shape: smooth bell curve
    float halfWidth = uWidth * 0.5;
    float band = smoothstep(halfWidth, 0.0, abs(dist));

    // Sharpen the peak for a convincing specular-like highlight
    band = pow(band, 1.8);

    // Secondary softer halo around the main band
    float halo = smoothstep(halfWidth * 2.5, 0.0, abs(dist)) * 0.2;

    // Subtle sparkle texture within the band
    float sparkleScale = 40.0;
    float sparkle = noise(uv * sparkleScale + uTime * 2.0);
    sparkle = smoothstep(0.55, 0.9, sparkle) * 0.4;

    // Combine band + halo + sparkle
    float shimmer = band + halo + sparkle * band;

    // Edge fade: soften near the widget edges to avoid harsh cutoff
    float edgeFadeX = smoothstep(0.0, 0.05, uv.x) * smoothstep(1.0, 0.95, uv.x);
    float edgeFadeY = smoothstep(0.0, 0.05, uv.y) * smoothstep(1.0, 0.95, uv.y);
    float edgeFade = edgeFadeX * edgeFadeY;

    shimmer *= edgeFade;

    // Perpendicular gradient: shimmer is brightest at center, fades at edges
    vec2 perpDir = vec2(-dir.y, dir.x);
    float perpDist = abs(dot(uv - 0.5, perpDir));
    float perpFade = smoothstep(0.6, 0.0, perpDist);
    shimmer *= 0.6 + perpFade * 0.4;

    shimmer = clamp(shimmer, 0.0, 1.0);

    // Apply color
    vec3 color = uColor * shimmer;
    float alpha = shimmer * uColor.r * 0.5 + shimmer * uColor.g * 0.3 + shimmer * uColor.b * 0.2;
    alpha = shimmer;

    fragColor = vec4(color * alpha, alpha);
}
