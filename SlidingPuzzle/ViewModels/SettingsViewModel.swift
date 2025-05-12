import Foundation

class SettingsViewModel: ObservableObject {
    @Published var settings: Settings {
        didSet {
            StorageManager.saveSettings(settings)
        }
    }

    init() {
        self.settings = StorageManager.loadSettings()
    }
}
