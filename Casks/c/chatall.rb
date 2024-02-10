cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.58.88"
  sha256 arm:   "6b269e5928f75e25088e4d136ab1986cb3024af1d3606b9b5c2fa9cb32c089ee",
         intel: "8bd52fb6628eba7c4b81e7bd599dfe0535781c6ed272c2c6586234e0bdfd1b3a"

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