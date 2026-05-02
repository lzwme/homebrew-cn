cask "aionui" do
  arch arm: "arm64", intel: "x64"

  version "1.9.24"
  sha256 arm:   "28544aa6952eac767ea7e5ecb48227fafda4a95d12a7a707500d5883ef09c9a0",
         intel: "13de39f54280f75c1f54dbb5991cbb751c4e1031cd62229d25170b20d8e1fd07"

  url "https://ghfast.top/https://github.com/iOfficeAI/AionUi/releases/download/v#{version}/AionUi-#{version}-mac-#{arch}.dmg"
  name "AionUi"
  desc "Unified GUI for command-line AI agents"
  homepage "https://github.com/iOfficeAI/AionUi"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "AionUi.app"

  zap trash: [
    "~/.aionui",
    "~/Library/Application Support/AionUi",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.aionui.app.sfl*",
    "~/Library/Preferences/com.aionui.app.plist",
    "~/Library/Saved Application State/com.aionui.app.savedState",
  ]
end