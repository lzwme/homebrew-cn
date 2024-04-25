cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.77.102"
  sha256 arm:   "fecb88f685d242fc650cbcefa8ddd3c67f00a9d8d6c159e9c79d197ba2a65a1e",
         intel: "63f6b7d6f50755123096d1813202e156b49c6e34f02b03d20c033bc61b95d032"

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