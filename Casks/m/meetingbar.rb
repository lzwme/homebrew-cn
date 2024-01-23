cask "meetingbar" do
  version "4.7.0"
  sha256 "042b47c13c1a16714b31d774a7fd89ba7800174dacbe64ad6690323cff129e53"

  url "https:github.comleitsMeetingBarreleasesdownloadv#{version}MeetingBar.dmg"
  name "MeetingBar"
  desc "Shows the next meeting in the menu bar"
  homepage "https:github.comleitsMeetingBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "MeetingBar.app"

  zap trash: [
    "~LibraryApplication Scriptsleits.MeetingBar",
    "~LibraryContainersleits.MeetingBar",
  ]
end