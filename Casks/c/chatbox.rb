cask "chatbox" do
  arch arm: "-arm64"

  version "1.2.1"
  sha256 arm:   "bb93e0e66ba9c95cb57970e23a2f24a10e9d503e04097b81214b02277fe3d1ba",
         intel: "bcf1f2603c2524fe0840d633da4200f1484208824e9ba6ef5af378381ac9dfa5"

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