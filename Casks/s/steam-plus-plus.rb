cask "steam-plus-plus" do
  version "3.0.0-rc.12"
  sha256 "cbb7d0aaf751d01f0a99a583f9430f67821a353f2e15fe3a018a6738d6d40d5e"

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