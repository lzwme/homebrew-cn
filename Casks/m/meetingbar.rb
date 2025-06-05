cask "meetingbar" do
  version "4.11.4"
  sha256 "ad9b4b98012f8186fc2e8ca4a4d823974cf29f1f59db83e52f9ebcaef93d8048"

  url "https:github.comleitsMeetingBarreleasesdownloadv#{version}MeetingBar.dmg"
  name "MeetingBar"
  desc "Shows the next meeting in the menu bar"
  homepage "https:github.comleitsMeetingBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  no_autobump! because: :bumped_by_upstream

  app "MeetingBar.app"

  zap trash: [
    "~LibraryApplication Scriptsleits.MeetingBar",
    "~LibraryContainersleits.MeetingBar",
  ]
end