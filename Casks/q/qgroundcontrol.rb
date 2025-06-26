cask "qgroundcontrol" do
  version "5.0.4"
  sha256 "88210b714dadcd888341f8751ad5ff3714bd342db627b70cfdf8dff9cac578a7"

  url "https:github.commavlinkqgroundcontrolreleasesdownloadv#{version}QGroundControl.dmg",
      verified: "github.commavlinkqgroundcontrol"
  name "QGroundControl"
  desc "Ground control station for drones"
  homepage "https:qgroundcontrol.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "QGroundControl.app"

  zap trash: [
    "~DocumentsQGroundControl",
    "~LibraryCachesQGroundControl.org",
    "~LibrarySaved Application Stateorg.qgroundcontrol.QGroundControl.savedState",
  ]
end