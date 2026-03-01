import SwiftUI
import UIKit

struct LobbyView: View {
    @ObservedObject var viewModel: LobbyViewModel
    let onMatchFound: (Match) -> Void

    var body: some View {
        ZStack {
            ArcadeBackground()
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: Header
                    VStack(spacing: 8) {
                        Text("TODAY'S BATTLE")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(ArcadeTheme.textPrimary)

                        Text("1v1 COMPETITIVE DOOMSCROLLING")
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .foregroundStyle(ArcadeTheme.textPrimary.opacity(0.86))
                            .tracking(0.6)
                    }
                    .padding(.top, 6)

                    // MARK: Explicit state branches – loading and error are dedicated renders
                    if viewModel.isLoading {
                        loadingContent
                    } else if let error = viewModel.errorMessage {
                        errorContent(message: error)
                    } else {
                        lobbyContent
                    }
                }
                .frame(maxWidth: 460)
                .padding(.horizontal, 20)
                .padding(.top, 54)
                .padding(.bottom, 28)
            }
        }
        .onChange(of: viewModel.currentMatch) { match in
            if let match, match.status == .inProgress {
                onMatchFound(match)
            }
        }
        // Normalize join-code input: uppercase, alphanumeric only, max 6 chars
        .onChange(of: viewModel.joinCodeInput) { newValue in
            let normalized = newValue
                .uppercased()
                .filter { $0.unicodeScalars.allSatisfy { CharacterSet.alphanumerics.contains($0) } }
            let trimmed = String(normalized.prefix(6))
            if trimmed != newValue {
                viewModel.joinCodeInput = trimmed
            }
        }
    }

    // MARK: – Loading branch
    private var loadingContent: some View {
        VStack(spacing: 10) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.25)
            Text(viewModel.statusMessage.isEmpty ? "PREPARING MATCH..." : viewModel.statusMessage.uppercased())
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(ArcadeTheme.textPrimary.opacity(0.85))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 24)
    }

    // MARK: – Error branch
    private func errorContent(message: String) -> some View {
        ArcadePanel(fill: ArcadeTheme.hotPink) {
            Text(message)
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(ArcadeTheme.textPrimary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: – Normal lobby content (idle / hosting / joining)
    @ViewBuilder
    private var lobbyContent: some View {
        switch viewModel.mode {
        case .idle:    idleContent
        case .hosting: hostingContent
        case .joining: joiningContent
        }
    }

    // MARK: – Idle state
    private var idleContent: some View {
        ArcadePanel(fill: ArcadeTheme.purpleFill) {
            VStack(spacing: 14) {
                Text("READY FOR BATTLE?")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(ArcadeTheme.textPrimary)

                Picker("Match Length", selection: $viewModel.selectedDuration) {
                    ForEach(MatchDuration.allCases) { duration in
                        Text(duration.label).tag(duration)
                    }
                }
                .pickerStyle(.segmented)

                Button { viewModel.createMatch() } label: { Text("CREATE MATCH") }
                    .buttonStyle(ArcadePrimaryButtonStyle(color: ArcadeTheme.lime, textColor: .black))

                Button { viewModel.beginJoinFlow() } label: { Text("JOIN WITH CODE") }
                    .buttonStyle(ArcadePrimaryButtonStyle(color: ArcadeTheme.cyan, textColor: .black))
            }
        }
        .disabled(viewModel.isLoading)
    }

    // MARK: – Hosting state
    private var hostingContent: some View {
        ArcadePanel(fill: ArcadeTheme.purpleFill) {
            VStack(spacing: 18) {
                Text("SHARE THIS MATCH CODE")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(ArcadeTheme.textPrimary)

                // Large monospaced code display – hot pink background with strong tracking
                Text(viewModel.hostedMatchCode.isEmpty ? "------" : viewModel.hostedMatchCode)
                    .font(.system(size: 34, weight: .bold, design: .monospaced))
                    .kerning(3)
                    .foregroundStyle(ArcadeTheme.textPrimary)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(ArcadeTheme.hotPink)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(ArcadeTheme.outline, lineWidth: ArcadeTheme.outlineWidth)
                    )

                if !viewModel.statusMessage.isEmpty {
                    Text(viewModel.statusMessage)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(ArcadeTheme.textPrimary.opacity(0.84))
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 12) {
                    Button {
                        UIPasteboard.general.string = viewModel.hostedMatchCode
                    } label: {
                        Text("COPY CODE")
                    }
                    .buttonStyle(ArcadePrimaryButtonStyle(color: ArcadeTheme.cyan, textColor: .black))

                    Button { viewModel.cancelHostedMatch() } label: { Text("CANCEL") }
                        .buttonStyle(ArcadePrimaryButtonStyle(color: ArcadeTheme.hotPink, textColor: .white))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: – Joining state
    private var joiningContent: some View {
        ArcadePanel(fill: ArcadeTheme.purpleFill) {
            VStack(spacing: 16) {
                Text("ENTER A 6-CHARACTER CODE")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(ArcadeTheme.textPrimary)

                // Large centred monospaced input – yellow background, black text
                TextField("A7K2P9", text: $viewModel.joinCodeInput)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled(true)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)
                    .background(ArcadeTheme.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ArcadeTheme.outline, lineWidth: ArcadeTheme.outlineWidth)
                    )
                    .foregroundStyle(.black)

                // JOIN is disabled until code is exactly 6 valid characters
                Button { viewModel.joinMatchWithCode() } label: { Text("JOIN MATCH") }
                    .buttonStyle(ArcadePrimaryButtonStyle(color: ArcadeTheme.lime, textColor: .black))
                    .disabled(viewModel.joinCodeInput.count != 6 || viewModel.isLoading)

                Button { viewModel.backToIdle() } label: { Text("BACK") }
                    .buttonStyle(ArcadePrimaryButtonStyle(color: ArcadeTheme.cyan, textColor: .black))
            }
        }
    }
}
