cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.37.3"
  sha256 arm:   "ee5e0816cc5c35bc3952df3084f866ba7d2f2fe5a8bc8163860b91228a6df772",
         intel: "1977a8c0afb1377f2f951b609e1734e0cf654452b2bc500386c42d9de3069c47"

  url "https:github.comWerWolvImHexreleasesdownloadv#{version}imhex-#{version}-macOS-#{arch}.dmg",
      verified: "github.comWerWolvImHex"
  name "ImHex"
  desc "Hex editor for reverse engineers"
  homepage "https:imhex.werwolv.net"

  app "ImHex.app"

  zap trash: [
    "~LibraryApplication Supportimhex",
    "~LibraryPreferencesnet.WerWolv.ImHex.plist",
    "~LibrarySaved Application Statenet.WerWolv.ImHex.savedState",
  ]
end