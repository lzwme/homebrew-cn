cask "deepchat" do
  arch arm: "arm64", intel: "x64"

  version "0.0.15"
  sha256  arm:   "ea6c4121565f9cfa0aee31d825c11b63897da1219edf88901caf4ee579ce32ff",
          intel: "37544f4ab591a1c0085becd3aac934bd2b5681c243fce5ee89a257e2426d9de8"

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