cask "syncthing" do
  version "1.27.10-1"
  sha256 "ca64b421b338c4174d063c74af6ef04feff48fc5c608b8edf7c04b8db92d5294"

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