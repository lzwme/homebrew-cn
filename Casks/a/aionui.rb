cask "aionui" do
  arch arm: "arm64", intel: "x64"

  version "1.8.16"
  sha256 arm:   "c1c562f40df742046be0b9c39e3d17b49d9ed28c77e9252ce3c4b8b542484ba4",
         intel: "9109594a265fe18f692fb6d936f8764ac58af93078f747c76838c27b9c25bf67"

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