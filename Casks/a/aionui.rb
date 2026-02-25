cask "aionui" do
  arch arm: "arm64", intel: "x64"

  version "1.8.17"
  sha256 arm:   "2e9a21be3ebf8d9868f848ff43e980065f0c0a5be4673155daf249b8949baaa0",
         intel: "aa93489f17fce2ea3cfe084619849863cc89e9958bd4a7390835ebc4b9ed5985"

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