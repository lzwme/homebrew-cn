cask "deepchat" do
  arch arm: "arm64", intel: "x64"

  version "0.0.16"
  sha256  arm:   "f1f689ca921803dade5a4e96a5ab7109b70f07387c1a423ff4d116e788f30725",
          intel: "293a2ec6d460144ca5ea81be3add3581c87c8dc3148719bab8746c8226afbeb1"

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