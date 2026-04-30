cask "aionui" do
  arch arm: "arm64", intel: "x64"

  version "1.9.22"
  sha256 arm:   "462e6f3cc5f9b2004f15a0dbfc719dc588b6e21fda4b31cd82865073684c6bd8",
         intel: "2b41ddefe411c95f1aa5ae4836762a6972bd31e37dfd3a88e0a46d9cdcd89471"

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