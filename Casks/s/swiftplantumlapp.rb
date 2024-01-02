cask "swiftplantumlapp" do
  version "1.6.0"
  sha256 "74b2c77abd793681f02e9ef310972aae0d601f290d708aaf8ba487c5a23f067d"

  url "https:github.comMarcoEidingerSwiftPlantUML-Xcode-Extensionreleasesdownload#{version}SwiftPlantUMLApp.zip"
  name "swiftplantumlapp"
  desc "Generate and view a class diagram for Swift code in Xcode"
  homepage "https:github.comMarcoEidingerSwiftPlantUML-Xcode-Extension"

  app "SwiftPlantUMLApp.app"

  zap trash: [
    "~LibraryApplication Scriptsus.eidinger.SwiftPlantUML",
    "~LibraryApplication Scriptsus.eidinger.SwiftPlantUMLSourceEditorExtension",
    "~LibraryContainersus.eidinger.SwiftPlantUML",
    "~LibraryGroup Containersus.eidinger.SwiftPlantUMLSourceEditorExtension",
  ]
end