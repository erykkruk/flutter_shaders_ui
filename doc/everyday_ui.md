# Everyday UI widgets

Widgets for ordinary app screens rather than showpiece effects. Each one
works with a single line, respects reduced motion and `ShaderPerformance`,
and keeps working (without the shader layer) if its shader cannot load.

## ShaderSkeleton

Skeleton loading placeholder. While `isLoading` is `true`, every pixel the
placeholder paints is recoloured to `baseColor`, and a `highlightColor` band
sweeps across. Gaps between shapes stay transparent, so the skeleton follows
your real layout. When loading finishes it cross-fades to `child`.

```dart
ShaderSkeleton(
  isLoading: posts == null,
  placeholder: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonBone(width: 160, height: 18),
      SizedBox(height: 8),
      SkeletonBone(),
      SizedBox(height: 8),
      SkeletonBone(width: 220),
    ],
  ),
  child: PostPreview(post: posts!.first),
)
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `isLoading` | required | Show the skeleton instead of `child` |
| `child` | required | Real content; also the skeleton shape when `placeholder` is null |
| `placeholder` | `null` | Layout used as the skeleton, typically `SkeletonBone`s |
| `baseColor` | theme-aware grey | Bone colour |
| `highlightColor` | theme-aware lighter grey | Sweep colour |
| `speed` | `1.0` | Sweep speed multiplier |
| `bandWidth` | `0.35` | Band width as a fraction of the surface (0.05 to 1.0) |
| `angle` | `0.35` | Sweep angle in radians |
| `fadeDuration` | 250 ms | Cross-fade to content; zero under reduced motion |
| `semanticsLabel` | `'Loading'` | Announced instead of the placeholder |

`SkeletonBone({width, height = 14, borderRadius})` and
`SkeletonBone.circle(size:)` sketch the shapes. Inside a skeleton they take
its bone colour, so the placeholder still looks right without the shader.

Accessibility: while loading, pointer input is ignored and the placeholder is
excluded from semantics, replaced by a live-region `semanticsLabel`.

## FrostedSurface

Frosted glass that really blurs what is behind it (`BackdropFilter` with
`ImageFilter.blur`), with a tint, a hairline border and a fine frost grain
from the glass shader.

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: FrostedSurface(
      borderRadius: BorderRadius.zero,
      child: AppBar(backgroundColor: Colors.transparent, title: const Text('Inbox')),
    ),
  ),
  body: const MessageList(),
)
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `child` | `null` | Content on the surface |
| `blurSigma` | `16` | Backdrop blur; `0` disables it |
| `tint` | theme-aware translucent white / near-black | Colour over the blur |
| `borderRadius` | 16 | Corner radius; the blur is clipped to it |
| `borderColor` | theme-aware translucent white | Hairline border colour |
| `borderWidth` | `1` | `0` removes the border |
| `frost` | `0.25` | Grain amount; `0` skips the shader |
| `animateFrost` | `false` | Let the grain drift (repaints every frame) |
| `padding` | `null` | Padding around `child` |
| `enabled` | `true` | `false` renders only the padded child |

Performance: the static grain renders once, so the per-frame cost is the
blur itself. Backdrop blur is the expensive part on low-end Android devices,
so avoid stacking many blurred surfaces at once.

## AnimatedGradientBorder

Rounded-rectangle ring with a rotating multi-colour sweep gradient and an
optional soft glow outside it.

```dart
AnimatedGradientBorder(
  enabled: isSelected,
  borderRadius: 18,
  glow: 0.6,
  glowSpread: 10,
  child: PlanCard(plan: plan),
)
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `child` | required | Widget the border surrounds |
| `colors` | violet, cyan, pink | 1 to 4 colours (extras ignored); the gradient wraps around |
| `borderWidth` | `2` | Ring thickness |
| `borderRadius` | `12` | Outer corner radius; large values give a pill |
| `speed` | `1.0` | One turn every 4 s; `0` keeps it still and stops repainting |
| `glow` | `0.0` | Glow strength (0 to 1), needs `glowSpread` |
| `glowSpread` | `0.0` | Space reserved outside the ring for the glow |
| `enabled` | `true` | `false` hides the ring but keeps the inset |

The child is inset by `borderWidth + glowSpread`. Keep `glowSpread` constant
and animate `glow` or `enabled` so selection changes never move the layout.
For a snug fit, give the child a radius of about `borderRadius - borderWidth`.
