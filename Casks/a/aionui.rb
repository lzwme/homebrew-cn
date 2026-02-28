cask "aionui" do
  arch arm: "arm64", intel: "x64"

  version "1.8.18"
  sha256 arm:   "02eb5834792011584d68c8b099a09ef639f8e8efa4eaa6ec81e3e53f2118bdfe",
         intel: "9de8794eb9a87ca812b0c801841cac14455b45ffb26fd7b95c5f33952634a0ec"

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