cask "chatbox" do
  arch arm: "-arm64"

  version "1.3.9"
  sha256 arm:   "88698941e8ad51b81f5f91bbebf4f693fd9d31c312d64ac848876c50df7b755f",
         intel: "4898396d83f0783f1eb4569b56f400459abb8c8b29147f9996ad702128fcad9e"

  url "https:github.comBin-Huangchatboxreleasesdownloadv#{version}Chatbox-#{version}#{arch}.dmg",
      verified: "github.comBin-Huangchatbox"
  name "chatbox"
  desc "Desktop app for GPT-4  GPT-3.5 (OpenAI API)"
  homepage "https:chatboxapp.xyz"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "chatbox.app"

  uninstall quit: "xyz.chatboxapp.app"

  zap trash: [
    "~LibraryApplication Supportxyz.chatboxapp.app",
    "~LibraryCachesxyz.chatboxapp.app",
    "~LibraryPreferencesxyz.chatboxapp.app.plist",
    "~LibrarySaved Application Statexyz.chatboxapp.app.savedState",
    "~LibraryWebKitxyz.chatboxapp.app",
  ]
end