import SwiftUI

// MARK: – Shared arcade UI primitives
// Build screens by composing these components; do not add one-off styling in views.

// MARK: - ArcadeDiagonalStripes

/// Faint diagonal-line texture used in all arcade backgrounds.
struct ArcadeDiagonalStripes: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let spacing = ArcadeTheme.stripeSpacing
                let w = geometry.size.width
                let h = geometry.size.height
                var x: CGFloat = -h
                while x < w + h {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x + h, y: h))
                    x += spacing
                }
            }
            .stroke(
                Color.white.opacity(ArcadeTheme.stripeOpacity),
                lineWidth: ArcadeTheme.stripeWidth
            )
        }
    }
}

// MARK: - ArcadeBackground

/// Full-screen background for the lobby / pre-match screens.
/// Dark purple-to-black gradient with diagonal stripe texture and a subtle bottom vignette.
struct ArcadeBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [ArcadeTheme.lobbyBgTop, ArcadeTheme.lobbyBgBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            ArcadeDiagonalStripes()
            LinearGradient(
                colors: [Color.black.opacity(0.08), Color.black.opacity(0.36)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - ArcadeGameplayBackground

/// Full-screen background for the active match screen.
/// Slightly deeper purple-to-black gradient with diagonal stripe texture.
struct ArcadeGameplayBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [ArcadeTheme.gameplayBgTop, ArcadeTheme.gameplayBgBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            ArcadeDiagonalStripes()
        }
    }
}

// MARK: - ArcadePanel

/// Thick-outlined, hard-shadowed rounded panel used for lobby content areas.
struct ArcadePanel<Content: View>: View {
    let fill: Color
    let content: Content

    init(fill: Color, @ViewBuilder content: () -> Content) {
        self.fill = fill
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(fill)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ArcadeTheme.outline, lineWidth: ArcadeTheme.heavyOutlineWidth)
                )
                .shadow(color: ArcadeTheme.shadowColor, radius: 0, x: 0, y: 7)
            content
                .padding(16)
        }
    }
}

// MARK: - ArcadeHUDPanel

/// Dark translucent panel for the in-match score/status HUD.
struct ArcadeHUDPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(ArcadeTheme.hudFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ArcadeTheme.outline, lineWidth: ArcadeTheme.outlineWidth)
                )
                .shadow(color: ArcadeTheme.shadowColor, radius: 0, x: 0, y: 4)
            content
                .padding(10)
        }
    }
}

// MARK: - ArcadePrimaryButtonStyle

/// Full-width arcade button with thick outline and hard press animation.
/// Parameterised by fill colour and text colour so lime/cyan/hot-pink variants share one style.
struct ArcadePrimaryButtonStyle: ButtonStyle {
    let color: Color
    let textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ArcadeTheme.outline, lineWidth: ArcadeTheme.outlineWidth)
                )
                .shadow(color: ArcadeTheme.shadowColor, radius: 0, x: 0, y: 5)
            configuration.label
                .font(.system(size: 17, weight: .black, design: .rounded))
                .foregroundStyle(textColor)
                .tracking(0.5)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 52)
        }
        .scaleEffect(configuration.isPressed ? 0.98 : 1)
        .offset(y: configuration.isPressed ? 1 : 0)
    }
}

// MARK: - ArcadeBadge

/// Two-line info badge (LABEL over VALUE) used in the top utility bar.
struct ArcadeBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 8, weight: .black, design: .rounded))
                .foregroundStyle(ArcadeTheme.textSecondary)
            Text(value)
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundStyle(ArcadeTheme.textPrimary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.black.opacity(0.5)))
        .overlay(Capsule().stroke(ArcadeTheme.outline, lineWidth: 2))
    }
}

// MARK: - SmallChip

/// Compact coloured capsule label used for VIDEO N and TIME N chips in the HUD.
struct SmallChip: View {
    let text: String
    let fill: Color

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .black, design: .rounded))
            .foregroundStyle(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(fill))
            .overlay(Capsule().stroke(ArcadeTheme.outline, lineWidth: 2))
    }
}

// MARK: - PlayerBadge

/// Circular avatar with player name label for the player/timer strip.
struct PlayerBadge: View {
    let name: String
    let accent: Color

    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(accent)
                .frame(width: 40, height: 40)
                .overlay(Circle().stroke(ArcadeTheme.outline, lineWidth: 3))
                .shadow(color: ArcadeTheme.shadowColor, radius: 0, x: 0, y: 4)
                .overlay(
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(.white)
                )
            Text(name)
                .font(.system(size: 9, weight: .black, design: .rounded))
                .foregroundStyle(ArcadeTheme.textPrimary)
        }
    }
}

// MARK: - ForfeitButton

/// Compact hot-pink outlined button in the top-left utility bar.
struct ForfeitButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(ArcadeTheme.hotPink)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ArcadeTheme.outline, lineWidth: 2.5)
                    )
                    .shadow(color: .black.opacity(0.8), radius: 0, x: 0, y: 3)
                Text("FORFEIT")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            .frame(width: 82, height: 34)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - TimerRing

/// Circular countdown ring shown in the player/timer strip.
struct TimerRing: View {
    let progress: Double
    let remaining: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.18), lineWidth: 5)
            Circle()
                .trim(from: 0, to: max(0, min(1, 1.0 - progress)))
                .stroke(
                    ArcadeTheme.lime,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            Text("\(remaining)")
                .font(.system(size: 21, weight: .black, design: .rounded))
                .foregroundStyle(ArcadeTheme.textPrimary)
        }
        .frame(width: 62, height: 62)
        .padding(4)
        .background(Circle().fill(Color.black.opacity(0.5)))
        .overlay(Circle().stroke(ArcadeTheme.outline, lineWidth: 3))
    }
}
