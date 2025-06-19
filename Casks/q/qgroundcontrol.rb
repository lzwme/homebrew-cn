cask "qgroundcontrol" do
  version "5.0.3"
  sha256 "8e8678b08d677fd3ad4ddb2314dab382089e2b8119443931b83bfa2cad84d4b0"

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