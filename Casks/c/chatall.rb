cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.61.93"
  sha256 arm:   "5b8c5e90c4a26d46d6877437ba56996cabc6396377943f0b6e68e956a6a98ce3",
         intel: "93c31967f642d384900acae0bd05a6ed8bd82e8ce3e3461aebdb88b1ae09d79a"

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