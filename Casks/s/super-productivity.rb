cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "17.2.4"
  sha256 arm:   "397edf2d4996a732b3422bd6b7901feb8afbec022b95b5d4eb6f518bdfad967c",
         intel: "a31c802b1c350c88d3bb60fbcbbc73a09ed5d63e529a37b9a72b9393e0ccbda0"

  url "https://ghfast.top/https://github.com/johannesjo/super-productivity/releases/download/v#{version}/superProductivity-#{arch}.dmg",
      verified: "github.com/johannesjo/super-productivity/"
  name "Super Productivity"
  desc "To-do list and time tracker"
  homepage "https://super-productivity.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Super Productivity.app"

  zap trash: [
    "~/Library/Application Support/superProductivity",
    "~/Library/Logs/superProductivity",
    "~/Library/Preferences/com.super-productivity.app.plist",
    "~/Library/Saved Application State/com.super-productivity.app.savedState",
  ]
end