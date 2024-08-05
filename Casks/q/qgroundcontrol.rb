cask "qgroundcontrol" do
  version "4.4.1"
  sha256 "e8cb292c9d4650c70a838ebb8f5acdbf81e55e6f55a35fcd167dc13d8365a3eb"

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

  caveats do
    requires_rosetta
  end
end