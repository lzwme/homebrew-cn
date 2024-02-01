cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.58.86"
  sha256 arm:   "50e0e5a4b4cca269a78207d868bdb27024fb464d8ffa4b750006d6709cc13a81",
         intel: "9b984bab7912cbb0dae3a5a48088b8b86bc3ddac22a6d99044999821d328f2be"

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