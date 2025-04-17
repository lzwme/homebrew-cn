cask "rocket-chat" do
  version "4.3.3"
  sha256 "f7fc54a770d687b157c2fd22c1e312419e5cbc5c15367607eb38c8236a5a90fe"

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