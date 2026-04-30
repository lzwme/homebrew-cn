cask "hive-app" do
  arch arm: "-arm64"

  version "1.0.125"
  sha256 arm:   "508ecfa2e3e1276ba676ac014d0305becd6531196d1535b58c0d42793aa1d712",
         intel: "04d8f1cc57e59d08b9ff0c23d8fa077e6bb7b41d11b6d54893ac12accf2e7543"

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