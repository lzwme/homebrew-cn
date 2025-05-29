cask "qgroundcontrol" do
  arch arm: "silicon", intel: "x86_64"

  version "4.4.5"
  sha256 arm:   "d6a114173110701395f3289a2c42ef74f25e9d2ade226936dbd27bfd8bbb969b",
         intel: "e6be1ef02653db7810f06dffc24303953b64483def8ec853a2e4da11510fe3a4"

  url "https:github.commavlinkqgroundcontrolreleasesdownloadv#{version}QGroundControl-#{arch}.dmg",
      verified: "github.commavlinkqgroundcontrol"
  name "QGroundControl"
  desc "Ground control station for drones"
  homepage "https:qgroundcontrol.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "QGroundControl.app"

  zap trash: [
    "~DocumentsQGroundControl",
    "~LibraryCachesQGroundControl.org",
    "~LibrarySaved Application Stateorg.qgroundcontrol.QGroundControl.savedState",
  ]

  caveats do
    requires_rosetta
  end
end