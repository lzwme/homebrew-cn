cask "meetingbar" do
  version "4.6.0"
  sha256 "9163902e45c0ac98f9d5d123974d6c5fb63e1187f2c18ca988cf4ff0a3d41998"

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