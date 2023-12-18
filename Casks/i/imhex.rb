cask "imhex" do
  version "1.31.0"
  sha256 "4f8b4256f5f3c8d7d7fb42ee8905f09b13b3b3e1ebe32abe10bf855f6ee35ce0"

  url "https:github.comWerWolvImHexreleasesdownloadv#{version}imhex-#{version}-macOS-x86_64.dmg",
      verified: "github.comWerWolvImHex"
  name "ImHex"
  desc "Hex editor for reverse engineers"
  homepage "https:imhex.werwolv.net"

  app "imhex.app"

  zap trash: [
    "~LibraryApplication Supportimhex",
    "~LibraryPreferencesnet.WerWolv.ImHex.plist",
    "~LibrarySaved Application Statenet.WerWolv.ImHex.savedState",
  ]
end