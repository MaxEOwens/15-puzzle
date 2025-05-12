import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Slider(value: $viewModel.settings.animationSpeed, in: 0.1...1.0) {
                Text("Animation Speed")
            }

            Picker("Control Style", selection: $viewModel.settings.controlStyle) {
                Text("Tap").tag("Tap")
                Text("Swipe").tag("Swipe")
            }

            Stepper("Inspection Time: \(viewModel.settings.inspectionTime)s", value: $viewModel.settings.inspectionTime, in: 1...10)
        }
        .navigationTitle("Settings")
    }
}
