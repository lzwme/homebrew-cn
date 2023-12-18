cask "steam-plus-plus" do
  arch arm: "arm64", intel: "x64"

  version "2.8.6"
  sha256 arm:   "772cfb10035f5dc290aa6a1e6f373826db4f45e8bd65e4d06083e4973b576dad",
         intel: "6c03b9358532254c2ae3329fcdbdad58c165f08343f759064f3a5c20bc59212e"

  url "https:github.comBeyondDimensionSteamToolsreleasesdownload#{version}Steam++_macos_#{arch}_v#{version}.dmg",
      verified: "github.comBeyondDimensionSteamTools"
  name "Steam++"
  desc "Steam helper tools"
  homepage "https:steampp.net"

  livecheck do
    url :url
    strategy :github_latest
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