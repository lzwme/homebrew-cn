cask "swiftformat-for-xcode" do
  version "0.53.2"
  sha256 "d08385f49d797d266e9e5815a308ec1275089ed1ffa554d95d76261a0a51a0ce"

  url "https:github.comnicklockwoodSwiftFormatreleasesdownload#{version}SwiftFormat.for.Xcode.app.zip"
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