cask "rocket-chat" do
  version "4.0.1"
  sha256 "80441ed659f8eefb89ec6a08404c18235e2a88730fc22c09dfc7bca347797d52"

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