cask "swiftformat-for-xcode" do
  version "0.53.3"
  sha256 "4fc786936fd0e9e6391b1e3af19216d014e387d9c746016f08a371f1fa9edc9b"

  url "https:github.comnicklockwoodSwiftFormatreleasesdownload#{version}SwiftFormat.for.Xcode.zip"
  name "SwiftFormat for Xcode"
  desc "Xcode Extension for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"

  depends_on macos: ">= :mojave"

  app "SwiftFormat for Xcode.app"

  zap trash: [
    "~LibraryApplication Scriptscom.charcoaldesign.SwiftFormat-for-Xcode",
    "~LibraryApplication Scriptscom.charcoaldesign.SwiftFormat-for-Xcode.SourceEditorExtension",
    "~LibraryContainerscom.charcoaldesign.SwiftFormat-for-Xcode",
    "~LibraryGroup Containerscom.charcoaldesign.SwiftFormat",
  ]
end