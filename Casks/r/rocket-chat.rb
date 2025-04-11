cask "rocket-chat" do
  version "4.3.1"
  sha256 "f9ee9ee2f52073eaf24e5a6bab5db425d776df1540438b3e3937a232ea754966"

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
  depends_on macos: ">= :big_sur"

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