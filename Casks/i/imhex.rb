cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.36.2"
  sha256 arm:   "9bf5c412ef74aa4d68a6c272b7492c57f9232771494e14aaabb5d74fdd99b6a2",
         intel: "82ca43c66f5f21c105dd931884e5eb2ac362ae0edd0a247b5a9d23398175a6a0"

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