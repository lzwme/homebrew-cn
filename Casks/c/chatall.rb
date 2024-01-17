cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.58.85"
  sha256 arm:   "e0433a640642022bb277d77fbaf0c71be981ae965a1f0e4e31ed26fc24ffd23f",
         intel: "8803eb54731c3455607ee71493553cef5212eb7b40720f0da8cc478bf2dfa98f"

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