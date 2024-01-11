cask "bluebubbles" do
  version "1.9.4"
  sha256 "877454804b1053bad8400d2b4e61f5b48d7d19e5e59ca4712072c669ff5279c4"

  url "https:github.comBlueBubblesAppbluebubbles-serverreleasesdownloadv#{version}BlueBubbles-#{version}.dmg",
      verified: "github.comBlueBubblesAppbluebubbles-server"
  name "BlueBubbles"
  desc "Server for forwarding iMessages"
  homepage "https:bluebubbles.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "BlueBubbles.app"

  uninstall launchctl:  "com.BlueBubbles.BlueBubbles-Server.ShipIt",
            quit:       [
              "com.BlueBubbles.BlueBubbles-Server",
              "com.BlueBubbles.BlueBubbles-Server.helper",
              "com.BlueBubbles.BlueBubbles-Server.helper.GPU",
              "com.BlueBubbles.BlueBubbles-Server.helper.Plugin",
              "com.BlueBubbles.BlueBubbles-Server.helper.Renderer",
              "com.bluebubbles.messaging",
            ],
            login_item: "BlueBubbles"

  zap trash: [
    "~LibraryApplication Support@bluebubbles",
    "~LibraryApplication Supportbluebubbles-server",
    "~LibraryLogs@bluebubbles",
    "~LibraryLogsbluebubbles-server",
    "~LibraryPreferencescom.BlueBubbles.BlueBubbles-Server.plist",
    "~LibrarySaved Application Statecom.BlueBubbles.BlueBubbles-Server.savedState",
  ]
end