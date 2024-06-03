cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.80.106"
  sha256 arm:   "cdd4bcc4dbfcbc09f94fc2785135e17f109b7e9138aa3134db0d3f0188e6ca7e",
         intel: "13a564f19dd7706c134d18b6f6988f5a376fa45273502b79320868001e80c2e1"

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