#include <flutter/runtime_effect.glsl>

// --- Standard uniforms ---
uniform vec2 uResolution;    // index 0-1
uniform float uTime;         // index 2

// --- Custom uniforms ---
uniform vec4 uBaseColor;     // index 3-6, bone colour (RGBA 0-1, straight alpha)
uniform vec4 uHighlight;     // index 7-10, sweep colour (RGBA 0-1, straight alpha)
uniform float uSpeed;        // index 11, sweeps per second multiplier
uniform float uBandWidth;    // index 12, band width as a fraction of the diagonal
uniform float uAngle;        // index 13, sweep angle in radians

out vec4 fragColor;

// Applied with BlendMode.srcATop over the placeholder, so this colour only
// lands where the placeholder painted something: bones get recoloured and
// the gaps between them stay transparent.
void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;

    vec2 dir = vec2(cos(uAngle), sin(uAngle));
    // Normalise the projection to 0..1 across the surface for any angle.
    float span = abs(dir.x) + abs(dir.y);
    float projection = (dot(uv - 0.5, dir) / span) + 0.5;

    // Travel from fully off one side to fully off the other, then repeat.
    float travel = 1.0 + uBandWidth * 2.0;
    float sweep = fract(uTime * uSpeed * 0.6) * travel - uBandWidth;

    float dist = abs(projection - sweep);
    float band = 1.0 - smoothstep(0.0, uBandWidth * 0.5, dist);
    band = band * band * (3.0 - 2.0 * band);

    vec4 color = mix(uBaseColor, uHighlight, band);
    fragColor = vec4(color.rgb * color.a, color.a);
}
