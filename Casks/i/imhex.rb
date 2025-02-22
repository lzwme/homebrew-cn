cask "imhex" do
  arch arm: "arm64", intel: "x86_64"

  version "1.37.1"
  sha256 arm:   "af6486def0e8c567923665fe25120ff220f95cfd2720699f823a45e4119388d6",
         intel: "0104ee2cf6e4076d38eaef43da2095f24b88bff9afa1921c294a79f553aa49b5"

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