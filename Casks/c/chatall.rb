cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.63.96"
  sha256 arm:   "157477516f66d549f3e5cf61de0e6b43e431d581d4270eceb096be4f721ca911",
         intel: "518f4599ef82b85d1a076827a4109ccd22e9dcf667073d1ced0738ce8436a9f0"

  url "https:github.comsunnerChatALLreleasesdownloadv#{version}ChatALL-#{version}-mac-#{arch}.dmg"
  name "ChatALL"
  desc "Concurrently chat with ChatGPT, Bing Chat, Bard, Claude, ChatGLM and more"
  homepage "https:github.comsunnerChatALL"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "ChatALL.app"

  zap trash: [
    "~LibraryApplication SupportChatALL",
    "~LibraryCachesai.chatall",
    "~LibraryPreferencesai.chatall.plist",
    "~LibrarySaved Application Stateai.chatall.savedState",
  ]
end