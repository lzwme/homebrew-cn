cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.33.2"
  sha256 arm:   "7b61556864d8156801364213e33b463e50373d49d77565cca9e68687bef5e0e2",
         intel: "97e59c85cb8ebc8bcd5b413ec09c6e462ee4e72a191474df53174e10b35be831"

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