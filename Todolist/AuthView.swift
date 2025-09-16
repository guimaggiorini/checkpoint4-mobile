import SwiftUI
import SwiftData

struct AuthView: View {
    @State private var selectedAuthTab: AuthTab = .signIn
    @State private var textHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.4))
                        .frame(width: 3, height: textHeight)
                        .cornerRadius(1.5)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("“Lorem ipsum dolor sit amet, consectetur adipiscing elit.”")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Arthur Mariano")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    textHeight = geo.size.height
                                }
                                .onChange(of: geo.size.height) { _, newHeight in
                                    textHeight = newHeight
                                }
                        }
                    )
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 25)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Quote of the day. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                
                Picker("Auth", selection: $selectedAuthTab) {
                    Text("Login").tag(AuthTab.signIn)
                    Text("Sign Up").tag(AuthTab.signUp)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                
                VStack {
                    switch selectedAuthTab {
                    case .signIn:
                        LoginView()
                    case .signUp:
                        SignupView()
                    }
                }
                Spacer()
            }
            .padding(.vertical, 16)
            .navigationTitle("Todolist")
        }
    }
}

private enum AuthTab {
    case signIn
    case signUp
}
