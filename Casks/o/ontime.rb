cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.8.0"
  sha256 arm:   "02f1023bdea737120f4d4f25ab9c841c0dc9ca176bee472241a83038749c7249",
         intel: "aebf4d20607bba6016b876fc9bd2e39575fa3db7e98ab99b6b0d7729a943adeb"

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