cask "swiftplantumlapp" do
  version "1.5.1"
  sha256 "0c2643219c9b5982592ce103f0824e2c36b501259e40b7e9b8114c37ddd091aa"

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