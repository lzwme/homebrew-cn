cask "pusher" do
  version "0.7.5"
  sha256 "b329a5106b6670bf50da4b91ba34d82102edb70074828cf4d0cd879b1a5e2180"

  url "https:github.comnoodlewerkNWPusherreleasesdownload#{version}pusher.app.zip"
  name "NWPusher"
  desc "Send push notifications through Apple Push Notification Service"
  homepage "https:github.comnoodlewerkNWPusher"

  app "Pusher.app"

  zap trash: [
    "~LibraryPusher",
    "~LibrarySaved Application Statecom.noodlewerk.Pusher.savedState",
  ]
end