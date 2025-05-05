cask "swiftformat-for-xcode" do
  version "0.55.6"
  sha256 "329074380aab503db5f191e2e38b990f100e64ee2d5a7d7d0f839abd0b0af2de"

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