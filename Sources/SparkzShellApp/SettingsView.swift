import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ShellViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("User Management")) {
                    Button("Set Root Password") {
                        viewModel.sendRootPasswordCommand()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
