cask "vibeproxy" do
  arch arm: "arm64", intel: "x86_64"

  version "1.8.289"
  sha256 arm:   "aee607f6eb696654bfaaa3e183295a1794aa452a2168d94322ded3e8fd1d8864",
         intel: "759931717e3eeba7cbd2e59a88f32c5953d16f5713a48ac06ddca2c4225c16c9"

  url "https://ghfast.top/https://github.com/automazeio/vibeproxy/releases/download/v#{version}/VibeProxy-#{arch}.dmg"
  name "VibeProxy"
  desc "Menu bar app for using AI subscriptions with coding tools"
  homepage "https://github.com/automazeio/vibeproxy"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "VibeProxy.app"

  zap trash: [
    "~/Library/HTTPStorages/com.vibeproxy.app",
    "~/Library/Preferences/com.vibeproxy.app.plist",
  ]
end