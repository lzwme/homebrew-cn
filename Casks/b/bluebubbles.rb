cask "bluebubbles" do
  version "1.9.2"
  sha256 "0bb63679d0ee15bae564dcfe73ad8c923cc0a2decb4e8c846ae178b333c4fd03"

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
            login_item: "BlueBubbles",
            quit:       [
              "com.BlueBubbles.BlueBubbles-Server",
              "com.BlueBubbles.BlueBubbles-Server.helper",
              "com.BlueBubbles.BlueBubbles-Server.helper.GPU",
              "com.BlueBubbles.BlueBubbles-Server.helper.Plugin",
              "com.BlueBubbles.BlueBubbles-Server.helper.Renderer",
              "com.bluebubbles.messaging",
            ]

  zap trash: [
    "~LibraryApplication Support@bluebubbles",
    "~LibraryApplication Supportbluebubbles-server",
    "~LibraryLogs@bluebubbles",
    "~LibraryLogsbluebubbles-server",
    "~LibraryPreferencescom.BlueBubbles.BlueBubbles-Server.plist",
    "~LibrarySaved Application Statecom.BlueBubbles.BlueBubbles-Server.savedState",
  ]
end