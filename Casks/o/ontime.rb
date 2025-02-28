cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.13.1"
  sha256 arm:   "d9158e32e8875f76aa2c44d7320363dbbb0edb57065e192e331a9af604f48c2b",
         intel: "46666eeb8eb40dcd4fdf17d7c864d0838a6c3bab39f5194bcaf8d536692e92ec"

  url "https:github.comcpvalenteontimereleasesdownloadv#{version}ontime-macOS-#{arch}.dmg",
      verified: "github.comcpvalenteontime"
  name "Ontime"
  desc "Time keeping for live events"
  homepage "https:getontime.no"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "ontime.app"

  zap trash: [
    "~LibraryApplication Supportontime",
    "~LibraryPreferencesno.lightdev.ontime.plist",
    "~LibrarySaved Application Stateno.lightdev.ontime.savedState",
  ]
end