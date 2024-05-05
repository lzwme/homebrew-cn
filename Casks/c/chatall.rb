cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.78.104"
  sha256 arm:   "20f064958096f24c53aaf1f872d7805fcc504d6f8dc7d3b553813cd3e7bedb12",
         intel: "8202452b337bd5146907e25ae1e1e5b4b9f73d7866298e3d2514d5fd0574c0c0"

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