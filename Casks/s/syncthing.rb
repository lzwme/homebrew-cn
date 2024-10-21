cask "syncthing" do
  version "1.28.0-1"
  sha256 "07536a9ccf89129fabf4aea6a0f947ed71ba2219768023d06af38c993b30f137"

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