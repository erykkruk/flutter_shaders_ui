#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;    // 0-1: widget size in pixels
uniform float uTime;         // 2:   elapsed seconds (unused, kept for standard layout)
uniform vec2 uTouchPoint;    // 3-4: normalized touch position (0-1)
uniform float uProgress;     // 5:   animation progress (0.0 to 1.0)
uniform float uIntensity;    // 6:   effect strength
uniform vec3 uColor;         // 7-9: ripple color (RGB, 0-1)

out vec4 fragColor;

const float PI = 3.14159265359;
const float RING_COUNT = 3.0;
const float RING_FREQUENCY = 28.0;
const float RING_SHARPNESS = 0.6;
const float MAX_RADIUS = 1.6;

/// Attempt a smooth, high-quality expanding ripple with multiple
/// concentric rings that fade as the wave front expands outward.
void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;

    // Aspect-corrected coordinates so rings stay circular.
    float aspect = uResolution.x / uResolution.y;
    vec2 correctedUV = vec2(uv.x * aspect, uv.y);
    vec2 correctedTouch = vec2(uTouchPoint.x * aspect, uTouchPoint.y);

    float dist = distance(correctedUV, correctedTouch);

    // Current wave front radius — expands over progress.
    float waveRadius = uProgress * MAX_RADIUS;

    // Distance from this pixel to the current wave front.
    float waveDist = dist - waveRadius;

    // Create multiple concentric rings via a high-frequency sine.
    float rings = sin(waveDist * RING_FREQUENCY - uProgress * PI * 4.0);

    // Sharpen the rings from a smooth sine into crisp bands.
    rings = pow(abs(rings), RING_SHARPNESS) * sign(rings);

    // Remap from [-1, 1] to [0, 1].
    rings = rings * 0.5 + 0.5;

    // Only show rings near the wave front (within a band).
    float bandWidth = 0.12 + uProgress * 0.18;
    float bandMask = smoothstep(bandWidth, 0.0, abs(waveDist));

    // Fade based on distance from touch — further rings are weaker.
    float distanceFade = 1.0 - smoothstep(0.0, MAX_RADIUS * 0.9, dist);

    // Smooth fade-in at the start and fade-out at the end of the animation.
    float progressFade = smoothstep(0.0, 0.15, uProgress)
                       * smoothstep(1.0, 0.7, uProgress);

    // Combine all contributions.
    float alpha = rings * bandMask * distanceFade * progressFade * uIntensity;

    // Add a subtle bright highlight at the leading edge of the wave front.
    float edgeHighlight = smoothstep(0.02, 0.0, abs(waveDist))
                        * progressFade
                        * distanceFade
                        * uIntensity
                        * 0.4;

    alpha += edgeHighlight;

    // Clamp to prevent over-bright pixels.
    alpha = clamp(alpha, 0.0, 1.0);

    fragColor = vec4(uColor * alpha, alpha);
}
