cask "tuta-mail" do
  version "240.240813.0"
  sha256 "ffe6c8942da2955e4c3c2c25d29552791b6c85b2c3dff4328cfb6271d20affa0"

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