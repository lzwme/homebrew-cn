cask "tuta-mail" do
  version "227.240429.0"
  sha256 "10aba809dda1055abf2b629a559e3d627b9fdece384a8b338aec06cc56621ad5"

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