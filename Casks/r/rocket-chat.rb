cask "rocket-chat" do
  version "4.1.2"
  sha256 "4f47a2c60c910b0ec1740f75d365363a42b366462044aada5f1bf70f29194d9a"

  url "https:github.comRocketChatRocket.Chat.Electronreleasesdownload#{version}rocketchat-#{version}-mac.dmg",
      verified: "github.comRocketChatRocket.Chat.Electron"
  name "Rocket.Chat"
  desc "Official desktop client for Rocket.Chat"
  homepage "https:rocket.chat"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Rocket.Chat.app"

  zap trash: [
    "~LibraryApplication SupportRocket.Chat",
    "~LibraryCacheschat.rocket",
    "~LibraryCacheschat.rocket.electron.helper",
    "~LibraryCacheschat.rocket.ShipIt",
    "~LibraryPreferenceschat.rocket.electron.helper.plist",
    "~LibraryPreferenceschat.rocket.plist",
    "~LibrarySaved Application Statechat.rocket.savedState",
  ]
end