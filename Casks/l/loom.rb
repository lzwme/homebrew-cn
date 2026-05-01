cask "loom" do
  arch arm: "-arm64"

  version "0.346.4"
  sha256 arm:   "b5de8b881cf43d4a370e846b47d3fa976b79eced3ba43ee17b906c19bf95d360",
         intel: "5507e3d7fad87bb9059c5f7dcd0dc47a6625f54041d3ad04cc0cb73e3f628d1e"

  url "https://packages.loom.com/desktop-packages/Loom-#{version}#{arch}.dmg"
  name "Loom"
  desc "Screen and video recording software"
  homepage "https://www.loom.com/"

  livecheck do
    url "https://packages.loom.com/desktop-packages/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Loom.app"

  uninstall login_item: "Loom"

  zap trash: [
    "~/Library/Application Support/Loom",
    "~/Library/Logs/Loom",
    "~/Library/Preferences/com.loom.desktop.plist",
    "~/Library/Saved Application State/com.loom.desktop.savedState",
  ]
end