cask "vibeproxy" do
  version "1.8.144"
  sha256 "21e4b722f384412c2b00d8b834f9d7a0183641d1c1c3549e76b131c5aed24122"

  url "https://ghfast.top/https://github.com/automazeio/vibeproxy/releases/download/v#{version}/VibeProxy-arm64.dmg"
  name "VibeProxy"
  desc "Menu bar app for using AI subscriptions with coding tools"
  homepage "https://github.com/automazeio/vibeproxy"

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "VibeProxy.app"

  zap trash: "~/Library/Preferences/com.vibeproxy.app.plist"
end