cask "chatall" do
  arch arm: "arm64", intel: "x64"

  version "1.59.91"
  sha256 arm:   "1f71c07006cd1c741ddf5d2f0efb7e02a2a67d9e857c337bdda3843532427453",
         intel: "5fa6892d3015437dbf3294b82e024c9981482d0762e2e3c6a263cd1fd7014253"

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