cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.58.84"
  sha256 arm:   "8e1a383d2daa9162a81d8ea7d4f3ea495725272227172b153c86643a196e05e7",
         intel: "4402ad0a6e7e1782967a192fd358886b4705d42e550ea0e1545409bc92478921"

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