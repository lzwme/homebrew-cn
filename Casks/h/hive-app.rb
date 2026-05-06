cask "hive-app" do
  arch arm: "-arm64"

  version "1.0.128"
  sha256 arm:   "3d32c71b7faefc05746ee2322641330978150c2e93278b737e76256390b44094",
         intel: "c270efca92c670ffb9a606544f777a62eb566779aebea0d325cd7c11d470578a"

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