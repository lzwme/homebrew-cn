cask "syncthing" do
  version "1.27.5-1"
  sha256 "34d0003bee1699f99a46521ce31bf49b32e5bdcfcfc712e7442da5e199a9a98a"

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
  depends_on macos: ">= :sierra"

  app "Syncthing.app"

  zap trash: [
    "~LibraryApplication SupportSyncthing-macOS",
    "~LibraryCachescom.github.xor-gate.syncthing-macosx",
    "~LibraryCookiescom.github.xor-gate.syncthing-macosx.binarycookies",
    "~LibraryPreferencescom.github.xor-gate.syncthing-macosx.plist",
  ]
end