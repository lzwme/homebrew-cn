cask "tuta-mail" do
  version "235.240709.0"
  sha256 "93cc3e8b14dd859ec71f0adb58705a15bb30c4a38616ea5d9e56bdd919ee7017"

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