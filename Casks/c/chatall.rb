cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.59.90"
  sha256 arm:   "c12aca8858d43d3fd1dcac46bf0350298a8889b6f848e67277107428d4b13f19",
         intel: "cece9d5b2717a3390c333cd32aa230ef487a2970be87166acfdc4e1b19df8213"

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