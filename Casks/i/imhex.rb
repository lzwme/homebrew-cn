cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.37.2"
  sha256 arm:   "305f80bde49904d5398b2d34ff2dba99585049f840b62432d732dd718109e562",
         intel: "26b7bdc27a9fae6612169c6c0568579244f9e757c321f26e9b1d90bf07a6f66d"

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