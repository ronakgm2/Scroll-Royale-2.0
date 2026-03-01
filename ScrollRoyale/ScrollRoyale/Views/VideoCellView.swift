import SwiftUI

struct VideoCellView: View {
    let item: ContentItem
    let index: Int
    let totalCount: Int
    let cellHeight: CGFloat
    let isActive: Bool
    let playbackTime: Double
    var onPlaybackTimeUpdate: ((Double) -> Void)?

    var body: some View {
        ZStack {
            // MARK: Video player + full-cell vignette
            VideoPlayerView(
                url: item.videoURL,
                isPlaying: isActive,
                playbackTime: playbackTime,
                onPlaybackTimeUpdate: onPlaybackTimeUpdate
            )
            .frame(maxWidth: .infinity)
            .overlay(
                LinearGradient(
                    colors: [Color.black.opacity(0.42), .clear, Color.black.opacity(0.42)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // MARK: Overlay chips
            // Padding values are calibrated to clear the top utility bar + player strip
            // and the bottom score HUD when the stage is positioned inside GameView.
            VStack {
                HStack {
                    videoIndexChip
                    Spacer()
                }
                .padding(.top, 96)
                .padding(.horizontal, 14)

                Spacer()

                if isActive {
                    swipeHintChip
                        .padding(.bottom, 134)
                }
            }
        }
        .frame(height: cellHeight)
    }

    // MARK: – "VIDEO X / N" chip (top-left, always visible)
    private var videoIndexChip: some View {
        Text("VIDEO \(index + 1) / \(totalCount)")
            .font(.system(size: 10, weight: .black, design: .rounded))
            .foregroundStyle(ArcadeTheme.textPrimary)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(Color.black.opacity(0.46))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(ArcadeTheme.outline, lineWidth: 2))
    }

    // MARK: – "SWIPE TO NEXT CLIP" chip (bottom-center, active reel only)
    private var swipeHintChip: some View {
        Text("SWIPE TO NEXT CLIP")
            .font(.system(size: 10, weight: .black, design: .rounded))
            .foregroundStyle(ArcadeTheme.textPrimary.opacity(0.86))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.44))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(ArcadeTheme.outline, lineWidth: 2))
    }
}

#Preview {
    VideoCellView(
        item: ContentItem(
            id: "1",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            duration: 60,
            order: 1
        ),
        index: 0,
        totalCount: 3,
        cellHeight: 600,
        isActive: true,
        playbackTime: 0
    )
}
