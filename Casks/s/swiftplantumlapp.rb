cask "swiftplantumlapp" do
  version "1.6.0"
  sha256 "74b2c77abd793681f02e9ef310972aae0d601f290d708aaf8ba487c5a23f067d"

  url "https://ghfast.top/https://github.com/MarcoEidinger/SwiftPlantUML-Xcode-Extension/releases/download/#{version}/SwiftPlantUMLApp.zip"
  name "SwiftPlantUMLApp"
  desc "Generate and view a class diagram for Swift code in Xcode"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML-Xcode-Extension"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "SwiftPlantUMLApp.app"

  zap trash: [
    "~/Library/Application Scripts/us.eidinger.SwiftPlantUML",
    "~/Library/Application Scripts/us.eidinger.SwiftPlantUMLSourceEditorExtension",
    "~/Library/Containers/us.eidinger.SwiftPlantUML",
    "~/Library/Group Containers/us.eidinger.SwiftPlantUMLSourceEditorExtension",
  ]
end