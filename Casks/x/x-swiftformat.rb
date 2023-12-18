cask "x-swiftformat" do
  version "2.0"
  sha256 "ebf9a23486607273e4c7d2f502963953b0c30e18927fd0715d376baa4cf492de"

  url "https:github.comruiaurelianoX-SwiftFormatreleasesdownload#{version}x-swiftformat_#{version}.zip"
  name "X-SwiftFormat"
  desc "Xcode extension to format Swift code"
  homepage "https:github.comruiaurelianoX-SwiftFormat"

  depends_on macos: ">= :ventura"

  app "X-SwiftFormat.app"

  zap trash: [
    "~LibraryCachescom.ruiaureliano.xswiftformat",
    "~LibraryContainerscom.ruiaureliano.xswiftformat",
    "~LibraryPreferencescom.ruiaureliano.xswiftformat.plist",
  ]
end