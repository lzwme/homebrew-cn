cask "deepchat" do
  arch arm: "arm64", intel: "x64"
  livecheck_arch = on_arch_conditional arm: "arm", intel: "x64"

  version "0.2.3"
  sha256 arm:   "5483c4bed0d68d8f351d4447506ade7bafd8634971827175f9cb86884ce2c870",
         intel: "52babd84944cc6762736bd5682e0c7fc6d33d28103f928f4d845102020b6a042"

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