cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.69.99"
  sha256 arm:   "eac056e6e9ee5de9f5bf0c6ff289fdc478a578b235cdf5c57b8cc20f97085ad4",
         intel: "417a7841f88664322e5e482e112b1e8b4adfcafa5514dfbb2144ddda61d65cf8"

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