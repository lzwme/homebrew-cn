cask "rclone-ui" do
  arch arm: "aarch64", intel: "x64"

  version "3.4.3"
  sha256 arm:   "6228534bcc2a25e3b03da293936b9a7495ae381ac9232c53459d35db4cff2c8d",
         intel: "cf9749619a4296a728fddf2f23c1b1c747ddd1c37c15480182dff972cb07e9ed"

  url "https://ghfast.top/https://github.com/rclone-ui/rclone-ui/releases/download/v#{version}/Rclone.UI_#{arch}.dmg"
  name "Rclone UI"
  desc "GUI for Rclone"
  homepage "https://github.com/rclone-ui/rclone-ui"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Rclone UI.app"

  zap trash: [
    "~/Library/Application Support/com.rclone.ui",
    "~/Library/Caches/com.rclone.ui",
    "~/Library/HTTPStorages/com.rclone.ui.binarycookies",
    "~/Library/Logs/com.rclone.ui",
    "~/Library/Preferences/com.rclone.ui.plist",
    "~/Library/Saved Application State/com.rclone.ui.savedState",
    "~/Library/WebKit/com.rclone.ui",
  ]
end