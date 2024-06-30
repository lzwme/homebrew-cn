cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.35.1"
  sha256 arm:   "e60d779dbbf2ffc31887b93d84fe1399e6d8a53a6bc5a5cc84fcb57e6d3ea7d0",
         intel: "0e94d4214c5d836dfacc6b7ec23174ca6fa0e524abe04f359818261e9e2890ab"

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