cask "meetingbar" do
  version "4.11.2"
  sha256 "8545631c3439d9ddac4fbc9ce058305adea78da9625aaf7b31f18b540459f920"

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