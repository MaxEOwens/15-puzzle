import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Picker("Control Style", selection: $viewModel.settings.controlStyle) {
                Text("Tap").tag("Tap")
                Text("Swipe").tag("Swipe")
                //                Text("Touch").tag("Touch")
            }

            Stepper("Inspection Time: \(viewModel.settings.inspectionTime)s", value: $viewModel.settings.inspectionTime, in: 1...30)
            Stepper("Inspection Warning Time: \(viewModel.settings.warningTime)s", value: $viewModel.settings.warningTime, in: 0...10)
            
            // background color
            // ColorPicker("Set background color", selection: $viewModel.settings.backgroundColor) //No exact matches in call to initializer
            // Need new way to pick color
            
            
            
            ColorPicker(
                "Set background color",
                selection: Binding(
                    get: { viewModel.settings.backgroundColor.color },
                    set: { viewModel.settings.backgroundColor = CodableColor(color: $0) }
                )
            )
            
            
            
            
        }
        .navigationTitle("Settings")
    }
}
