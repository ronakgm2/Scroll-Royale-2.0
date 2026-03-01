import SwiftUI

// MARK: – Arcade design-system tokens
// All magic numbers for the arcade visual identity live here.
// Views must reference these tokens instead of inlining raw values.

enum ArcadeTheme {

    // MARK: Background gradients

    /// Lobby / pre-match screen top colour (darkest purple-black)
    static let lobbyBgTop    = Color(red: 0.05, green: 0.04, blue: 0.09)
    /// Lobby / pre-match screen bottom colour (near-black)
    static let lobbyBgBottom = Color(red: 0.02, green: 0.02, blue: 0.05)
    /// Active gameplay screen top colour (slightly more purple)
    static let gameplayBgTop    = Color(red: 0.09, green: 0.04, blue: 0.16)
    /// Active gameplay screen bottom colour
    static let gameplayBgBottom = Color(red: 0.03, green: 0.02, blue: 0.06)

    // MARK: Brand fills

    /// Purple – panel backgrounds, YOU player badge
    static let purpleFill = Color(red: 0.48, green: 0.17, blue: 0.75)
    /// Lime – primary actions, live score, timer ring arc
    static let lime       = Color(red: 0.22, green: 1.00, blue: 0.08)
    /// Cyan – secondary actions, time chip
    static let cyan       = Color(red: 0.30, green: 0.79, blue: 0.94)
    /// Hot pink – destructive actions, RIVAL badge, forfeit, match-code display
    static let hotPink    = Color(red: 1.00, green: 0.00, blue: 0.43)
    /// Yellow – code-entry fields, video-index chip
    static let yellow     = Color(red: 0.99, green: 0.84, blue: 0.04)

    // MARK: Surface fills

    static let hudFill   = Color.black.opacity(0.62)
    static let stageFill = Color.black.opacity(0.70)

    // MARK: Borders & shadows

    static let outline:            Color   = .black
    static let outlineWidth:       CGFloat = 3
    static let heavyOutlineWidth:  CGFloat = 4
    static let shadowColor                 = Color.black.opacity(0.85)

    // MARK: Text

    static let textPrimary   = Color.white
    static let textSecondary = Color.white.opacity(0.75)

    // MARK: Diagonal-stripe texture

    static let stripeSpacing: CGFloat = 26
    static let stripeOpacity: Double  = 0.06
    static let stripeWidth:   CGFloat = 2
}
