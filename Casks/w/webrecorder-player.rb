cask "webrecorder-player" do
  version "1.8.0"
  sha256 "c7ecc7b19c31814a15a1dc5bff41ac899b239877d5968b057b0946b250aedd3a"

  url "https://ghfast.top/https://github.com/webrecorder/webrecorder-player/releases/download/v#{version}/webrecorder-player-#{version}.dmg"
  name "Webrecorder Player"
  homepage "https://github.com/webrecorder/webrecorder-player/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued, replacement_cask: "replaywebpage"

  app "Webrecorder Player.app"

  zap trash: [
    "~/Library/Application Support/Webrecorder Player",
    "~/Library/Preferences/org.webrecorder.webrecorderplayer.helper.plist",
    "~/Library/Preferences/org.webrecorder.webrecorderplayer.plist",
    "~/Library/Saved Application State/org.webrecorder.webrecorderplayer.savedState",
  ]
end