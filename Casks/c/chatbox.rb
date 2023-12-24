cask "chatbox" do
  arch arm: "-arm64"

  version "1.2.2"
  sha256 arm:   "80b8a87e2c0a7faae88e9bed67d9c80c6ec01e25c02be7c3a75e9c757c950bf9",
         intel: "3f633ca5a4b24d06a539ac841fc526c37a784b7c62535b1fd4b43609e64d9529"

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