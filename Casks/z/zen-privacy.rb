cask "zen-privacy" do
  arch arm: "arm64", intel: "amd64"

  version "0.21.0"
  sha256 arm:   "79e4a9b7ad6c5b88a7d1e3a7713c662357f2297caaaf56874e0b7b9e0ec54399",
         intel: "53ed4f0bb7bfb6cfe8ed3984ae37eb3b437f70e14317bce9ed13c3bcd7d20686"

  url "https://ghfast.top/https://github.com/ZenPrivacy/zen-desktop/releases/download/v#{version}/Zen_darwin_#{arch}_noselfupdate.tar.gz",
      verified: "github.com/ZenPrivacy/zen-desktop/"
  name "Zen"
  desc "Ad-blocker and privacy guard"
  homepage "https://zenprivacy.net/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "zen"
  depends_on :macos

  app "Zen.app"

  uninstall script: {
    executable:   "/Applications/Zen.app/Contents/MacOS/Zen",
    args:         ["--uninstall-ca"],
    must_succeed: false,
  }

  zap trash: [
    "~/Library/Application Support/Zen",
    "~/Library/Caches/Zen",
    "~/Library/LaunchAgents/net.zenprivacy.zen.plist",
    "~/Library/Logs/Zen",
    "~/Library/Preferences/net.zenprivacy.zen.plist",
    "~/Library/Saved Application State/net.zenprivacy.zen.savedState",
    "~/Library/WebKit/net.zenprivacy.zen",
  ]
end