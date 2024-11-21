cask "bluebubbles" do
  arch arm: "-arm64"

  version "1.9.8"
  sha256 arm:   "b2f997d9f09e5a0502cc605af798ba3af38c744d2050d1c53f534f99d3060bde",
         intel: "0a014c5ca614b492eec09d1da9756632fdd4d6c8a90bdbda6442401f0d967122"

  url "https:github.comBlueBubblesAppbluebubbles-serverreleasesdownloadv#{version}BlueBubbles-#{version}#{arch}.dmg",
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