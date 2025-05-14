cask "swiftformat-for-xcode" do
  version "0.56.0"
  sha256 "26d076a64f910aa584954e0633ac5cd0c8a8a6df0c0b08730b6a702cc4a4aa42"

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