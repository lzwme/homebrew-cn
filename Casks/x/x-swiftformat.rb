cask "x-swiftformat" do
  version "2.0.1"
  sha256 "987fb40b489fd78d563ea16afa510e75ff6a8b73677459eb164baeb5446809dd"

  url "https:github.comruiaurelianoX-SwiftFormatreleasesdownload#{version}x-swiftformat_#{version}.zip"
  name "X-SwiftFormat"
  desc "Xcode extension to format Swift code"
  homepage "https:github.comruiaurelianoX-SwiftFormat"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :ventura"

  app "X-SwiftFormat.app"

  zap trash: [
    "~LibraryCachescom.ruiaureliano.xswiftformat",
    "~LibraryContainerscom.ruiaureliano.xswiftformat",
    "~LibraryPreferencescom.ruiaureliano.xswiftformat.plist",
  ]
end