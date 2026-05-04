cask "hive-app" do
  arch arm: "-arm64"

  version "1.0.126"
  sha256 arm:   "4b4f377a100b66b3ae1ff81dbf47e55fed2d21627bd3d50627f305a39fcc79d4",
         intel: "89d88db6f8e1c6367d8b355f874d1165606375ccfdfc92cc3794d518cd45edd3"

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