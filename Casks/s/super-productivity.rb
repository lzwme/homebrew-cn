cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "18.4.4"
  sha256 arm:   "6bf9d7deb26eb8eb758d131d8ace50f4d8fb57e008e052906d565ab6e5c93ed2",
         intel: "0808c11633b108ee9d0ea3fb35255f263d7599a657d878cdb7064b0b8f548b47"

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