cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "18.4.3"
  sha256 arm:   "e585f6b25a9a0621d555e5da7e5a09d320b00eeedb45a85f1fdda546dd1da487",
         intel: "0bd7a16e58ac8489c66b658729013473bc24f8620b2b16b7cdc4ca313feb631e"

  url "https://ghfast.top/https://github.com/johannesjo/super-productivity/releases/download/v#{version}/superProductivity-#{arch}.dmg",
      verified: "github.com/johannesjo/super-productivity/"
  name "Super Productivity"
  desc "To-do list and time tracker"
  homepage "https://super-productivity.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Super Productivity.app"

  zap trash: [
    "~/Library/Application Support/superProductivity",
    "~/Library/Logs/superProductivity",
    "~/Library/Preferences/com.super-productivity.app.plist",
    "~/Library/Saved Application State/com.super-productivity.app.savedState",
  ]
end