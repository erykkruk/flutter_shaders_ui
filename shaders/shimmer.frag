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

    // Main band: smooth gaussian-like bell
    float halfWidth = uWidth * 0.5;
    float band = smoothstep(halfWidth, 0.0, abs(dist));
    band = band * band; // sharpen peak

    // Soft halo glow around band
    float halo = smoothstep(halfWidth * 3.0, 0.0, abs(dist)) * 0.15;

    // Combine
    float shimmer = band + halo;

    // Edge fade to avoid hard cutoff at widget borders
    float edgeFade = smoothstep(0.0, 0.08, uv.x) * smoothstep(1.0, 0.92, uv.x)
                   * smoothstep(0.0, 0.08, uv.y) * smoothstep(1.0, 0.92, uv.y);
    shimmer *= edgeFade;

    // Perpendicular fade: brightest at center line, fades at edges
    vec2 perpDir = vec2(-dir.y, dir.x);
    float perpDist = abs(dot(uv - 0.5, perpDir));
    shimmer *= smoothstep(0.5, 0.0, perpDist);

    shimmer = clamp(shimmer, 0.0, 1.0);

    vec3 color = uColor * shimmer;
    fragColor = vec4(color, shimmer);
}
