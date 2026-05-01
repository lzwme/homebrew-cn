cask "renameclick" do
  arch arm: "arm64", intel: "x64"

  version "2.9.2"
  sha256 arm:   "fbc083dab54c1c44d86796e4d42b73908bc91af83a304fd849c19cc876daa951",
         intel: "8db7d4b30a82d6818cf0b9f196996e2b4c7c41ad1c0704e3e573f544e4e6c624"

  url "https://ghfast.top/https://github.com/noemaVision/renameclick/releases/download/v#{version}/RenameClick-#{version}-#{arch}.dmg",
      verified: "github.com/noemaVision/renameclick/"
  name "RenameClick"
  desc "Local-first AI app for file renaming and organisation"
  homepage "https://rename.click/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "RenameClick.app"

  zap trash: [
    "~/Library/Application Support/RenameClick",
    "~/Library/Caches/com.renameclick.app",
    "~/Library/Caches/com.renameclick.app.helper",
    "~/Library/HTTPStorages/com.renameclick.app",
    "~/Library/Logs/renameclick.log",
    "~/Library/Preferences/com.renameclick.app.helper.plist",
    "~/Library/Preferences/com.renameclick.app.plist",
    "~/Library/Saved Application State/com.renameclick.app.savedState",
    "~/Library/WebKit/com.renameclick.app",
  ]
end