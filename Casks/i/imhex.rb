cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.37.0"
  sha256 arm:   "1c746e279eaae44e4f6661e4f8af1b3271a0b42f2aaaca65cceddc8d8b3093f8",
         intel: "224922f58799848b411400cdb13743f443cfc88cc539e84d8606d5e3ea3f4856"

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