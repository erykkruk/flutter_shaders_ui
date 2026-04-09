#include <flutter/runtime_effect.glsl>

// Standard uniforms
uniform vec2 uResolution;   // 0-1
uniform float uTime;        // 2

// Custom uniforms
uniform float uBlurAmount;  // 3  blur intensity (0-1)
uniform float uFrost;       // 4  frost noise amount (0-1)
uniform float uOpacity;     // 5  overall opacity (0-1)
uniform vec3 uTint;         // 6-8 tint color (RGB 0-1)

out vec4 fragColor;

// --- Noise utilities ---

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float hash3(vec3 p) {
    return fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453123);
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

// Fractal Brownian Motion for layered frost texture
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.2;
        amplitude *= 0.5;
    }
    return value;
}

// Voronoi distance for crystalline frost pattern
float voronoi(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float minDist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = vec2(hash(i + neighbor),
                              hash(i + neighbor + vec2(31.0, 17.0)));
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

// Second-order voronoi for richer crystalline edges
float voronoiEdges(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float d1 = 1.0;
    float d2 = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = vec2(hash(i + neighbor),
                              hash(i + neighbor + vec2(31.0, 17.0)));
            float dist = length(neighbor + point - f);
            if (dist < d1) {
                d2 = d1;
                d1 = dist;
            } else if (dist < d2) {
                d2 = dist;
            }
        }
    }
    return d2 - d1;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;

    float aspect = uResolution.x / uResolution.y;

    // Slow, subtle animation for living-glass feel
    float t = uTime * 0.08;

    // --- Frost noise pattern ---
    // Multi-scale frost texture combining fbm and voronoi
    vec2 frostUV = uv * 6.0;
    frostUV.x *= aspect;

    // Animated frost crawl
    frostUV += vec2(t * 0.3, t * 0.2);

    // Layered noise for organic frost
    float frostNoise = fbm(frostUV * 2.0 + t * 0.5);
    float frostNoise2 = fbm(frostUV * 4.0 - t * 0.3 + 100.0);

    // Crystalline structure from voronoi cells
    float crystals = voronoi(frostUV * 3.0 + t * 0.1);
    float crystalEdges = voronoiEdges(frostUV * 3.0 + t * 0.1);

    // Combine frost layers: organic noise + crystalline edges
    float frost = frostNoise * 0.5 + frostNoise2 * 0.3;
    frost += crystalEdges * 0.4;
    frost += (1.0 - crystals) * 0.2;
    frost = clamp(frost, 0.0, 1.0);

    // Scale frost intensity by user parameter
    frost *= uFrost;

    // --- Simulated blur distortion ---
    // Create the feeling of frosted/blurred glass via noise-based
    // luminance variation (light scattering simulation)
    vec2 blurUV = uv * 3.0;
    blurUV.x *= aspect;

    float scatter = 0.0;
    float blurScale = uBlurAmount * 0.5;

    // Multi-octave light scattering
    scatter += noise(blurUV * 8.0 + t * 1.5) * 0.4;
    scatter += noise(blurUV * 16.0 - t * 1.2) * 0.25;
    scatter += noise(blurUV * 32.0 + t * 0.8) * 0.15;
    scatter += noise(blurUV * 64.0 - t * 0.5) * 0.08;

    // Normalize and scale by blur amount
    scatter = scatter * blurScale;

    // --- Internal refraction highlights ---
    // Subtle caustic-like light patterns inside the glass
    vec2 refractUV = uv * 4.0 + t * 0.2;
    refractUV.x *= aspect;

    float caustic1 = noise(refractUV * 5.0 + vec2(t * 0.4, -t * 0.3));
    float caustic2 = noise(refractUV * 8.0 - vec2(t * 0.2, t * 0.5));
    float caustics = caustic1 * caustic2;
    caustics = pow(caustics, 1.5) * 0.6;

    // Refraction intensity scales with blur
    caustics *= uBlurAmount * 0.8;

    // --- Edge highlight / specular reflection ---
    // Soft gradient highlight simulating light reflecting off the glass surface
    // Positioned at upper-left for natural lighting feel
    vec2 highlightCenter = vec2(0.3, 0.3);
    float highlightDist = distance(uv, highlightCenter);
    float highlight = exp(-highlightDist * highlightDist * 3.0) * 0.15;
    highlight *= uBlurAmount;

    // Secondary smaller specular spot
    vec2 specCenter = vec2(0.25, 0.25);
    float specDist = distance(uv, specCenter);
    float spec = exp(-specDist * specDist * 12.0) * 0.1;
    spec *= uBlurAmount;

    // --- Subtle edge darkening (glass bevel feel) ---
    vec2 edgeUV = uv - 0.5;
    float edgeDist = max(abs(edgeUV.x), abs(edgeUV.y));
    float edgeDarken = smoothstep(0.35, 0.5, edgeDist) * 0.08;

    // --- Compose final color ---
    // Base tinted glass color
    vec3 color = uTint;

    // Add frost pattern as luminance variation on top of tint
    vec3 frostColor = mix(color, vec3(1.0), frost * 0.6);

    // Add light scatter (brightening through diffusion)
    frostColor += vec3(scatter) * 0.3;

    // Add caustic refractions
    frostColor += vec3(caustics) * 0.3;

    // Add specular highlights
    frostColor += vec3(highlight + spec);

    // Subtract edge darkening for depth
    frostColor -= vec3(edgeDarken);

    // --- Alpha compositing ---
    // Base alpha from opacity parameter
    float alpha = uOpacity;

    // Frost pattern adds to opacity (frosted areas are more opaque)
    alpha += frost * 0.15;

    // Light scatter slightly increases perceived opacity
    alpha += scatter * 0.05;

    alpha = clamp(alpha, 0.0, 1.0);

    // Clamp color to valid range
    frostColor = clamp(frostColor, 0.0, 1.0);

    // Premultiplied alpha output for correct compositing
    fragColor = vec4(frostColor * alpha, alpha);
}
