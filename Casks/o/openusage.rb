cask "openusage" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.22"
  sha256 arm:   "75bdc829a6ff993d6200a01555eade01d24d2ed7501b5a9332a6aa61862a7808",
         intel: "6afb7af47bb284ad6e77e3d42f9af246aef8b961d6f56110a2d4c5df3000001f"

  url "https://ghfast.top/https://github.com/robinebers/openusage/releases/download/v#{version}/OpenUsage_#{version}_#{arch}.dmg",
      verified: "github.com/robinebers/openusage/"
  name "OpenUsage"
  desc "AI usage tracker for Cursor, Claude Code, Codex, Copilot and more"
  homepage "https://www.openusage.ai/"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "OpenUsage.app"

  zap trash: [
    "~/Library/Application Support/com.sunstory.openusage",
    "~/Library/Caches/com.sunstory.openusage",
    "~/Library/HTTPStorages/com.sunstory.openusage",
    "~/Library/Preferences/com.sunstory.openusage.plist",
    "~/Library/Saved Application State/com.sunstory.openusage.savedState",
    "~/Library/WebKit/com.sunstory.openusage",
  ]
end