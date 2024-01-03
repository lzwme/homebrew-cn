cask "syncthing" do
  version "1.27.2-1"
  sha256 "2499735405051f5fb0fd76845593d62b96777fb1ca4dd7e914098860ff095703"

  url "https:github.comsyncthingsyncthing-macosreleasesdownloadv#{version}Syncthing-#{version}.dmg",
      verified: "github.comsyncthingsyncthing-macos"
  name "Syncthing"
  desc "Real time file synchronization software"
  homepage "https:syncthing.net"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Syncthing.app"

  zap trash: [
    "~LibraryApplication SupportSyncthing-macOS",
    "~LibraryCachescom.github.xor-gate.syncthing-macosx",
    "~LibraryCookiescom.github.xor-gate.syncthing-macosx.binarycookies",
    "~LibraryPreferencescom.github.xor-gate.syncthing-macosx.plist",
  ]
end