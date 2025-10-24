import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ShellViewModel()
    @State private var isShowingSettings = false

    var body: some View {
        NavigationStack {
            TerminalView(viewModel: viewModel)
                .navigationTitle("SparkzShell")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingSettings = true
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .sheet(isPresented: $isShowingSettings) {
                    SettingsView(viewModel: viewModel)
                }
        }
        .onAppear {
            viewModel.startShell()
        }
    }
}
