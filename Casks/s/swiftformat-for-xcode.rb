cask "swiftformat-for-xcode" do
  version "0.54.4"
  sha256 "9d33e1f1bf6d0636181af5863a5bdf39fb097be85996a614b591c01fa6023dcc"

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