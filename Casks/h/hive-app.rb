cask "hive-app" do
  arch arm: "-arm64"

  version "1.1.1"
  sha256 arm:   "8badc41ec868cb8b0a9594195d9acf5a1eeae5c62aaf88eaae21788bcbd0b318",
         intel: "f2e3a263454139ea2062cafc0b4a906d813bc0b17e528a92990b68b85e6af766"

  url "https://ghfast.top/https://github.com/morapelker/hive/releases/download/v#{version}/Hive-#{version}#{arch}.dmg"
  name "Hive"
  desc "AI agent orchestrator for parallel coding across projects"
  homepage "https://github.com/morapelker/hive"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Hive.app"

  zap trash: [
    "~/.hive",
    "~/Library/Application Support/hive",
    "~/Library/Logs/hive",
    "~/Library/Preferences/com.hive.app.plist",
    "~/Library/Saved Application State/com.hive.app.savedState",
  ]
end