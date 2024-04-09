cask "tuta-mail" do
  version "220.240408.0"
  sha256 "dc8dfb5ae3a1188fb6690f41599bcd3885a05681743c4427473a96849f9bb52c"

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