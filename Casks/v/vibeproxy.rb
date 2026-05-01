cask "vibeproxy" do
  version "1.8.142"
  sha256 "7afb95819ad27b29d15a6159515f11a8aa571a91819e516c5e7e29ca8a5f194a"

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