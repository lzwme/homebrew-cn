cask "rocket-chat" do
  version "3.9.11"
  sha256 "554c73f37dab507d0695f9de4a4828abe82e24b269646040035afde9a7c30709"

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