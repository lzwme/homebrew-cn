cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.35.4"
  sha256 arm:   "9869d897f7388fd7db8448f56a4c4cb614b4f9ce9e2f997239ed435ed98e748b",
         intel: "fae42fe1338c238bc6ddbc4b44b9c27b7a02c6c8da9780c34e05471762554960"

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