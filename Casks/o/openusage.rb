cask "openusage" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.20"
  sha256 arm:   "17b1c14eaa911db1725babcf1ecf387503a88d659cc43ecf2191148b43cc3ad7",
         intel: "ff8b33f389a953014fd598dd079ea1d376a5d8013b71529fb4a48a58a4c1e294"

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