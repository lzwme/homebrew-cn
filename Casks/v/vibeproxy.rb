cask "vibeproxy" do
  version "1.8.141"
  sha256 "b7da436adcfb94bfd6e6f32134b9ab3faf3b0c4114a698c463b6af1ce85b2e68"

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