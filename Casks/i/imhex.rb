cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.35.3"
  sha256 arm:   "c9eb556324246243bdcfdda3350a90f5c9c8f86c8a86fb74367bf28b36b1cfc1",
         intel: "715f06a1b61ed2d3b391d000f8f898ae4e1ba60f0071ea108b58429daa6d8e24"

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