cask "syncthing" do
  version "1.27.12-1"
  sha256 "a13f8db1d63cafa36ec11e75c4128c1f1cdbc9e2cce59cd80ec6ded58a9fb412"

  url "https:github.comsyncthingsyncthing-macosreleasesdownloadv#{version}Syncthing-#{version}.dmg",
      verified: "github.comsyncthingsyncthing-macos"
  name "Syncthing"
  desc "Real time file synchronisation software"
  homepage "https:syncthing.net"

  livecheck do
    url :url
    regex(v?(\d+(?:[\.\-]\d+)+)i)
    strategy :github_latest
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