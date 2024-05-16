cask "chatbox" do
  arch arm: "-arm64"

  version "1.3.10"
  sha256 arm:   "deeb54bf37d7451c3796dbcac5cbb0f834fe54d5d0f652aa5b4f274abf6bf5c6",
         intel: "8cf9a89e225d88dc18a1a5daebb7226503528ab3904a5912ee117d5d2ca1534e"

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