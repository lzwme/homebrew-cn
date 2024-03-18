cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.63.95"
  sha256 arm:   "3a71ceb5899b30149d2013c7109ac3761168985d89a4159940c458763b0123e8",
         intel: "f0318ee70e65b3e90150830bf093e5fa146e7e551ca4d5c8add23c321e896053"

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