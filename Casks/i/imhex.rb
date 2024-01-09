cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.32.2"
  sha256 arm:   "f49acd76bd683b1f6c2f3df6b6a272ad5f003275db768643d716505a900e83a0",
         intel: "8b9df7832c4cd6c329a19dfad0d89d6db0f0bcb562d8a1ec45241289f093942c"

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