import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    let onExit: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ArcadeGameplayBackground()
                    .ignoresSafeArea()

                VStack(spacing: 8) {

                    // MARK: 1 – Top utility bar
                    HStack(alignment: .top) {
                        ForfeitButton(action: onExit)
                        Spacer()
                        HStack(spacing: 6) {
                            ArcadeBadge(title: "MATCH",  value: viewModel.matchCode)
                            ArcadeBadge(title: "STATUS", value: viewModel.matchStatusLabel)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, max(8, geometry.safeAreaInsets.top + 4))

                    // MARK: 2 – Player / timer strip
                    HStack(alignment: .center) {
                        PlayerBadge(name: "YOU",   accent: ArcadeTheme.purpleFill)
                        Spacer()
                        TimerRing(progress: viewModel.timerProgress, remaining: viewModel.remainingSeconds)
                        Spacer()
                        PlayerBadge(name: "RIVAL", accent: ArcadeTheme.hotPink)
                    }
                    .padding(.horizontal, 18)

                    Spacer(minLength: 0)

                    // MARK: 3 – Main video stage
                    videoStage
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, 10)

                    // MARK: 4 – Bottom score HUD
                    ArcadeHUDPanel {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("LIVE SCORE")
                                    .font(.system(size: 9, weight: .black, design: .rounded))
                                    .foregroundStyle(ArcadeTheme.textSecondary)
                                Text("\(Int(viewModel.localScore))")
                                    .font(.system(size: 22, weight: .black, design: .rounded))
                                    .foregroundStyle(ArcadeTheme.lime)
                            }
                            Spacer()
                            HStack(spacing: 6) {
                                SmallChip(
                                    text: "VIDEO \(viewModel.currentVideoIndex + 1)",
                                    fill: ArcadeTheme.yellow
                                )
                                SmallChip(
                                    text: "TIME \(viewModel.remainingSeconds)s",
                                    fill: ArcadeTheme.cyan
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 12)

                    Spacer(minLength: 0)
                        .frame(height: 8)
                }
            }
        }
        .onAppear  { viewModel.startSync() }
        .onDisappear { viewModel.stopSync() }
    }

    // MARK: – Video stage container
    // The outer ZStack keeps the stage frame stable across all three internal states.
    // Do not move state-branch content outside this container.
    @ViewBuilder
    private var videoStage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(ArcadeTheme.stageFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(ArcadeTheme.outline, lineWidth: ArcadeTheme.outlineWidth)
                )
                .shadow(color: ArcadeTheme.shadowColor, radius: 0, x: 0, y: 6)

            // Three explicit internal states – order matters: empty check precedes loading check
            if viewModel.contentItems.isEmpty && !viewModel.isLoading {
                // Empty state
                VStack(spacing: 8) {
                    Text("NO VIDEOS READY")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(ArcadeTheme.textPrimary)
                    Text(viewModel.feedStatusMessage ?? "Try again in a moment.")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(ArcadeTheme.textPrimary.opacity(0.82))
                }
                .multilineTextAlignment(.center)
            } else if viewModel.contentItems.isEmpty {
                // Loading state
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                // Ready state – full-height reel feed
                VideoFeedView(
                    items: viewModel.contentItems,
                    scrollOffset: $viewModel.scrollOffset,
                    currentIndex: $viewModel.currentVideoIndex,
                    playbackTime: $viewModel.videoPlaybackTime,
                    onScroll: { offset, index, time in
                        viewModel.handleScroll(offset: offset, videoIndex: index, playbackTime: time)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(4)
            }
        }
    }
}
