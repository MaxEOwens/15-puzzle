struct Settings: Codable {
    var animationSpeed: Double
    var controlStyle: String
    var inspectionTime: Int

    static let `default` = Settings(animationSpeed: 0.3, controlStyle: "Tap", inspectionTime: 5)
}
