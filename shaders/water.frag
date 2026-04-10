#include <flutter/runtime_effect.glsl>

// Standard uniforms
uniform vec2 uResolution;       // 0-1
uniform float uTime;            // 2

// Custom uniforms
uniform float uSpeed;           // 3  animation speed
uniform float uDepth;           // 4  water depth (affects darkening, 0-1)
uniform float uWaveIntensity;   // 5  wave distortion (0-1)
uniform float uCausticIntensity;// 6  caustic brightness (0-1)
uniform float uFoamAmount;      // 7  foam/froth amount (0-1)
uniform vec3 uColor1;           // 8-10  shallow water color (RGB 0-1)
uniform vec3 uColor2;           // 11-13 deep water color (RGB 0-1)

out vec4 fragColor;

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

float fbm(vec2 p) {
    float value = 0.0;
    float amp = 0.5;
    float freq = 1.0;
    for (int i = 0; i < 5; i++) {
        value += amp * noise(p * freq);
        freq *= 2.1;
        amp *= 0.5;
    }
    return value;
}

// --- Voronoi for caustic light patterns ---

float voronoi(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float minDist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = vec2(
                hash(i + neighbor),
                hash(i + neighbor + vec2(31.0, 17.0))
            );
            // Animate voronoi points for caustic movement
            point = 0.5 + 0.5 * sin(uTime * 0.6 + 6.2831 * point);
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

// Second caustic layer with different cell animation
float voronoi2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float minDist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = vec2(
                hash(i + neighbor + vec2(73.0, 53.0)),
                hash(i + neighbor + vec2(91.0, 43.0))
            );
            point = 0.5 + 0.5 * sin(uTime * 0.45 + 6.2831 * point);
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

// --- Caustic pattern ---
// Layered voronoi cells create convincing underwater light caustics
float caustics(vec2 uv) {
    float t = uTime * uSpeed * 0.4;

    // Two voronoi layers at different scales and speeds
    vec2 p1 = uv * 5.0 + vec2(t * 0.3, t * 0.2);
    vec2 p2 = uv * 7.0 - vec2(t * 0.2, t * 0.35);

    float v1 = voronoi(p1);
    float v2 = voronoi2(p2);

    // Combine: multiply creates sharp bright intersections
    float c = v1 * v2;

    // Sharpen the caustic lines
    c = pow(c, 0.7);

    // Add a finer detail layer
    vec2 p3 = uv * 12.0 + vec2(t * 0.15, -t * 0.1);
    float v3 = voronoi(p3);
    c = c * 0.7 + v3 * 0.3;

    return c;
}

// --- Wave surface distortion ---
vec2 waveDistort(vec2 uv) {
    float t = uTime * uSpeed;
    float intensity = uWaveIntensity * 0.03;

    // Multiple sine wave layers for organic movement
    float dx = sin(uv.y * 8.0 + t * 1.2) * intensity;
    dx += sin(uv.y * 15.0 - t * 0.8 + uv.x * 3.0) * intensity * 0.5;
    dx += sin(uv.x * 6.0 + uv.y * 4.0 + t * 0.6) * intensity * 0.3;

    float dy = sin(uv.x * 7.0 + t * 0.9) * intensity;
    dy += sin(uv.x * 13.0 + t * 1.1 - uv.y * 2.0) * intensity * 0.5;
    dy += cos(uv.y * 5.0 + uv.x * 3.0 - t * 0.7) * intensity * 0.3;

    return vec2(dx, dy);
}

// --- Foam pattern ---
float foam(vec2 uv) {
    float t = uTime * uSpeed * 0.5;

    // Turbulence-based foam (absolute value noise for sharp edges)
    vec2 foamUV = uv * 4.0 + vec2(t * 0.2, t * 0.15);
    float n1 = abs(noise(foamUV * 3.0) * 2.0 - 1.0);
    float n2 = abs(noise(foamUV * 6.0 + 50.0) * 2.0 - 1.0);
    float n3 = abs(noise(foamUV * 12.0 + 100.0) * 2.0 - 1.0);

    float turb = n1 * 0.5 + n2 * 0.3 + n3 * 0.2;

    // Threshold to create foam patches
    float foamPattern = smoothstep(0.55 - uFoamAmount * 0.3, 0.7, turb);

    // Add flowing movement
    float flow = noise(uv * 2.0 + vec2(t * 0.3, -t * 0.1));
    foamPattern *= smoothstep(0.3, 0.6, flow);

    return foamPattern;
}

// --- Surface highlights (specular reflections on wave crests) ---
float surfaceHighlight(vec2 uv) {
    float t = uTime * uSpeed;

    // Wave height field using multiple sine layers
    float h = 0.0;
    h += sin(uv.x * 6.0 + uv.y * 2.0 + t * 1.1) * 0.3;
    h += sin(uv.x * 3.0 - uv.y * 5.0 + t * 0.7) * 0.2;
    h += sin(uv.x * 10.0 + uv.y * 8.0 - t * 1.5) * 0.15;
    h += noise(uv * 8.0 + t * 0.3) * 0.2;

    // Derive "slope" from height for specular
    float hx = h - sin((uv.x + 0.01) * 6.0 + uv.y * 2.0 + t * 1.1) * 0.3;
    float slope = abs(hx) * 50.0;

    // Sharp highlight on crests
    float highlight = exp(-slope * slope * 2.0) * 0.6;

    // Add subtle sparkle
    float sparkle = noise(uv * 30.0 + t * 2.0);
    sparkle = pow(sparkle, 8.0) * 0.4;

    return highlight + sparkle;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;
    float aspect = uResolution.x / uResolution.y;

    // Correct for aspect ratio
    vec2 uvCorrected = uv;
    uvCorrected.x *= aspect;

    // Apply wave distortion to UV coordinates
    vec2 distortion = waveDistort(uvCorrected);
    vec2 distortedUV = uvCorrected + distortion;

    // --- Base water color ---
    // Depth-based color mixing with subtle variation
    float depthNoise = fbm(distortedUV * 3.0 + uTime * uSpeed * 0.1);
    float depthFactor = uDepth * (0.5 + depthNoise * 0.5);
    depthFactor = clamp(depthFactor, 0.0, 1.0);
    vec3 waterColor = mix(uColor1, uColor2, depthFactor);

    // --- Caustic light patterns ---
    float causticPattern = caustics(distortedUV);
    // Brighter caustics in shallow areas
    float causticStrength = uCausticIntensity * (1.0 - depthFactor * 0.5);
    // Additive caustic glow
    vec3 causticColor = vec3(causticPattern) * causticStrength * 0.8;

    // Color the caustics slightly — warm light through water
    causticColor *= vec3(1.0, 0.95, 0.85);

    waterColor += causticColor;

    // --- Surface highlights ---
    float highlights = surfaceHighlight(distortedUV);
    waterColor += vec3(highlights) * 0.3 * (1.0 - depthFactor * 0.7);

    // --- Foam ---
    float foamPattern = foam(distortedUV) * uFoamAmount;
    // Foam is white/light
    vec3 foamColor = vec3(0.9, 0.95, 1.0);
    waterColor = mix(waterColor, foamColor, foamPattern * 0.7);

    // --- Subtle wave shadow/highlight ---
    // Creates 3D feel on the water surface
    float waveShadow = sin(distortedUV.x * 5.0 + uTime * uSpeed * 0.8)
                     * sin(distortedUV.y * 4.0 - uTime * uSpeed * 0.6);
    waveShadow = waveShadow * 0.04 * uWaveIntensity;
    waterColor += vec3(waveShadow);

    // --- Edge darkening for depth ---
    vec2 center = uv - 0.5;
    float vignette = 1.0 - dot(center, center) * 0.4 * uDepth;
    waterColor *= vignette;

    // Clamp to valid range
    waterColor = clamp(waterColor, 0.0, 1.0);

    fragColor = vec4(waterColor, 1.0);
}
