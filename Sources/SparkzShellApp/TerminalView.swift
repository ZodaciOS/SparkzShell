import SwiftUI

struct TerminalView: View {
    @ObservedObject var viewModel: ShellViewModel
    @State private var currentInput: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    Text(viewModel.terminalOutput)
                        .font(.custom("Menlo", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .id("TerminalBottom")
                }
                .onChange(of: viewModel.terminalOutput) {
                    proxy.scrollTo("TerminalBottom", anchor: .bottom)
                }
            }
            
            HStack(spacing: 0) {
                TextField(
                    "",
                    text: $currentInput,
                    prompt: Text("").font(.custom("Menlo", size: 12))
                )
                .font(.custom("Menlo", size: 12))
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($isInputFocused)
                .onSubmit {
                    handleSubmit()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                
                Button(action: handleSubmit) {
                    Image(systemName: "return")
                        .padding(.horizontal, 10)
                }
                .padding(.vertical, 8)
            }
            .background(.bar)
        }
        .onAppear {
            isInputFocused = true
        }
    }
    
    private func handleSubmit() {
        let input = currentInput
        currentInput = ""
        viewModel.sendInput(input)
    }
}
