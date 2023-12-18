cask "qgroundcontrol" do
  version "4.3.0"
  sha256 :no_check

  url "https:d176tv9ibo4jno.cloudfront.netlatestQGroundControl.dmg",
      verified: "d176tv9ibo4jno.cloudfront.netlatest"
  name "QGroundControl"
  desc "Ground control station for drones"
  homepage "http:qgroundcontrol.com"

  livecheck do
    url "https:github.commavlinkqgroundcontrolreleases"
    strategy :github_latest
  end

  app "qgroundcontrol.app"

  zap trash: [
    "~DocumentsQGroundControl",
    "~LibraryCachesQGroundControl.org",
    "~LibrarySaved Application Stateorg.qgroundcontrol.QGroundControl.savedState",
  ]
end