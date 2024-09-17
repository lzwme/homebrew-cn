cask "tuta-mail" do
  version "244.240913.1"
  sha256 "61e71d364b14d5c2c51e356d88073eeed946c1e49fc0fe090ef60a7c79af8a2d"

  url "https:github.comtutaotutanotareleasesdownloadtutanota-desktop-release-#{version}tutanota-desktop-mac.dmg",
      verified: "github.comtutaotutanota"
  name "Tuta Mail"
  desc "Email client"
  homepage "https:tuta.com"

  livecheck do
    url "https:app.tuta.comdesktoplatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Tuta Mail.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsde.tutao.tutanota.sfl*",
    "~LibraryApplication Supporttutanota-desktop",
    "~LibraryCachesde.tutao.tutanota",
    "~LibraryCachesde.tutao.tutanota.ShipIt",
    "~LibraryPreferencesde.tutao.tutanota.plist",
  ]
end