import Foundation
import SparkzBridge

@MainActor
class ShellViewModel: ObservableObject {
    @Published var terminalOutput: String = ""
    
    private let engine = SparkzEngine()
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleData(_:)),
            name: SparkzOutputNotification,
            object: nil
        )
    }
    
    @objc private func handleData(_ notification: Notification) {
        if let str = notification.object as? String {
            self.terminalOutput.append(str)
        }
    }
    
    func startShell() {
        engine.start()
    }
    
    func sendInput(_ input: String) {
        let fullCommand = input + "\n"
        terminalOutput.append(fullCommand)
        engine.sendInput(fullCommand)
    }
    
    func sendRootPasswordCommand() {
        let command = "passwd\n"
        terminalOutput.append(command)
        engine.sendInput(command)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
