cask "deepchat" do
  arch arm: "arm64", intel: "x64"

  version "0.1.1"
  sha256 arm:   "2fa5012bff8f93f295840c5d1c9de788eba1748c0c269b070dc27a91617727b7",
         intel: "2c3ca1e586b40066a4f4e1da963c3bb09bbe4838fc36286e59215791033f09de"

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