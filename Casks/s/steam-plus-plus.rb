cask "steam-plus-plus" do
  version "3.0.0-rc.13"
  sha256 "761ba21cf31e00dd24a28bf67076d12a14a5be48e72bb478dd21aa674dc47902"

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

  depends_on macos: ">= :monterey"

  app "Steam++.app"

  zap trash: [
    "~LibraryCachesSteam++",
    "~LibraryPreferencesnet.steampp.app.plist",
    "~LibrarySaved Application Statenet.steampp.app.savedState",
    "~LibrarySteam++",
  ]
end