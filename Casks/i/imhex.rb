cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.37.4"
  sha256 arm:   "de93acf0b1ae4c45812270061e7ad8b82e29e4b16fe15fc35a063e4050568d4e",
         intel: "d84c88246ca98b2462e970ff517bbcc351bda481bd34ab2d6e1fe14ee088e359"

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