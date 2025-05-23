cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.85.110"
  sha256 arm:   "6ee01d013d9b6f871ddbf9ab4518594b8e4c503f6f5d5c9f8a8bdd1cbf413855",
         intel: "8fe8ab4efc0d1a725e79765ad7b9a53b48be0432f96b3791f8e9beedd5cecf08"

  url "https:github.comsunnerChatALLreleasesdownloadv#{version}ChatALL-#{version}-mac-#{arch}.dmg"
  name "ChatALL"
  desc "Concurrently chat with ChatGPT, Bing Chat, Bard, Claude, ChatGLM and more"
  homepage "https:github.comsunnerChatALL"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "ChatALL.app"

  zap trash: [
    "~LibraryApplication SupportChatALL",
    "~LibraryCachesai.chatall",
    "~LibraryPreferencesai.chatall.plist",
    "~LibrarySaved Application Stateai.chatall.savedState",
  ]
end