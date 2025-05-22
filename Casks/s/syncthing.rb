cask "syncthing" do
  version "1.29.6-1"
  sha256 "87a6bdc5ce91e95a61e75970385b2d4a17c2373175efe0b955fdf0b7028c8c4d"

  url "https:github.comsyncthingsyncthing-macosreleasesdownloadv#{version}Syncthing-#{version}.dmg",
      verified: "github.comsyncthingsyncthing-macos"
  name "Syncthing"
  desc "Real time file synchronisation software"
  homepage "https:syncthing.net"

  livecheck do
    url "https:upgrades.syncthing.netsyncthing-macosappcast.xml"
    strategy :sparkle do |item|
      item.short_version.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Syncthing.app"

  zap trash: [
    "~LibraryApplication SupportSyncthing-macOS",
    "~LibraryCachescom.github.xor-gate.syncthing-macosx",
    "~LibraryCookiescom.github.xor-gate.syncthing-macosx.binarycookies",
    "~LibraryPreferencescom.github.xor-gate.syncthing-macosx.plist",
  ]
end