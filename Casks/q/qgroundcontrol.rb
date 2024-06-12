cask "qgroundcontrol" do
  version "4.4.0"
  sha256 "c11691a91b35ae5aff27be7a63afc93f74415734727ece6745ac79d6169c987c"

  url "https:github.commavlinkqgroundcontrolreleasesdownloadv#{version}QGroundControl.dmg",
      verified: "github.commavlinkqgroundcontrol"
  name "QGroundControl"
  desc "Ground control station for drones"
  homepage "http:qgroundcontrol.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "qgroundcontrol.app"

  zap trash: [
    "~DocumentsQGroundControl",
    "~LibraryCachesQGroundControl.org",
    "~LibrarySaved Application Stateorg.qgroundcontrol.QGroundControl.savedState",
  ]
end