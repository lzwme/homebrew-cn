cask "imhex" do
  version "1.32.1"
  sha256 "80b1c9b178f3fe44593fc63026d02d85ad282b2aa1ea51fb6e25073edbbfae36"

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