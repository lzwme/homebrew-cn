cask "deepchat" do
  arch arm: "arm64", intel: "x64"
  livecheck_arch = on_arch_conditional arm: "arm", intel: "x64"

  version "0.2.5"
  sha256 arm:   "575460b2bb5367392690c230e13194159de66373acf67a2946ffa8137d83e1a0",
         intel: "381bf4e28bffb7f4c90635d757510ea6f877b905aa43f44f7f8d2f3b9f38efee"

  url "https:github.comThinkInAIXYZdeepchatreleasesdownloadv#{version}DeepChat-#{version}-mac-#{arch}.dmg",
      verified: "github.comThinkInAIXYZdeepchat"
  name "DeepChat"
  desc "AI assistant"
  homepage "https:deepchat.thinkinai.xyz"

  livecheck do
    url "https:cdn.deepchatai.cnupgrademac#{livecheck_arch}.json"
    strategy :json do |json|
      json["version"]
    end
  end

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