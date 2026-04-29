cask "vibeproxy" do
  version "1.8.140"
  sha256 "1dc6c8dca3700a44b0c173fe24e22269e83769c3eda9e6cb4be58b04e3e9a7fc"

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