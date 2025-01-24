cask "steam-plus-plus" do
  version "3.0.0-rc.14"
  sha256 "c412db0a8a49ba9179c3398aed5d32d653d5f2d7feeb88150d7d15df6a18e2df"

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