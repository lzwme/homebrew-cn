cask "deepchat" do
  arch arm: "arm64", intel: "x64"

  version "0.1.0"
  sha256  arm:   "dcb4cf1f9b0867355735c552eb87c6db6196f35190b397fd838750f317b9fff7",
          intel: "2ca9636be84a74c1d0a3ccc1110bcb1b8209ed5b7a49b482823508f226e525f7"

  url "https:github.comThinkInAIXYZdeepchatreleasesdownloadv#{version}DeepChat-#{version}-mac-#{arch}.dmg",
      verified: "github.comThinkInAIXYZdeepchat"
  name "DeepChat"
  desc "AI assistant"
  homepage "https:deepchat.thinkinai.xyz"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "DeepChat.app"
  binary "#{appdir}DeepChat.appContentsMacOSDeepChat", target: "deepchat"

  zap trash: [
    "~LibraryApplication SupportDeepChat",
    "~LibraryLogsDeepChat",
    "~LibraryPreferencescom.wefonk.deepchat.plist",
    "~LibrarySaved Application Statecom.wefonk.deepchat.savedState",
  ]
end