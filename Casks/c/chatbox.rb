cask "chatbox" do
  arch arm: "-arm64"

  version "1.3.5"
  sha256 arm:   "7ac6ac022bce12a5268b1fcc87a97a2d4e73fee1f86842d52a0806c75d72b8f9",
         intel: "acc69284ee6425b7f589754d461da120b817dc794c469ce4b5ff57b27e181e03"

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