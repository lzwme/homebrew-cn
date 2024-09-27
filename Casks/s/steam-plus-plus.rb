cask "steam-plus-plus" do
  version "3.0.0-rc.11"
  sha256 "65840b8ac366617ece949bad1a0cca73e6d661603ef5059f6b7ae7dec1fc865b"

  url "https:github.comBeyondDimensionSteamToolsreleasesdownload#{version}Steam++_v#{version}_macos.dmg",
      verified: "github.comBeyondDimensionSteamTools"
  name "Steam++"
  desc "Steam helper tools"
  homepage "https:steampp.net"

  livecheck do
    url :url
    strategy :github_latest
    regex(v?(\d+(?:\.\d+)+(?:-rc\.(\d+)?))i)
  end

  depends_on macos: ">= :mojave"

  app "Steam++.app"

  zap trash: [
    "~LibraryCachesSteam++",
    "~LibraryPreferencesnet.steampp.app.plist",
    "~LibrarySaved Application Statenet.steampp.app.savedState",
    "~LibrarySteam++",
  ]
end