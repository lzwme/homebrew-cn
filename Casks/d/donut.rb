cask "donut" do
  arch arm: "aarch64", intel: "x64"

  version "0.22.4"
  sha256 arm:   "72ddf4fa896a0077fcdd99f5e04813988a5fd73d1901c114ecde2dfe5daa5979",
         intel: "cf6f7e2b0df48df88d5f144f4a9895d6fa850618cff3b09ce8a67741361dddb5"

  url "https://ghfast.top/https://github.com/zhom/donutbrowser/releases/download/v#{version}/Donut_#{version}_#{arch}.dmg",
      verified: "github.com/zhom/donutbrowser/"
  name "Donut Browser"
  desc "Anti-detect web browser"
  homepage "https://donutbrowser.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "donut@nightly"
  depends_on macos: ">= :big_sur"

  app "Donut.app"

  uninstall quit: "com.donutbrowser"

  zap trash: [
    "~/Library/Application Support/com.donutbrowser.Donut-Browser",
    "~/Library/Application Support/DonutBrowser",
    "~/Library/Caches/com.donutbrowser",
    "~/Library/Caches/DonutBrowser",
    "~/Library/LaunchAgents/com.donutbrowser.daemon.plist",
    "~/Library/Logs/com.donutbrowser",
    "~/Library/Preferences/com.donutbrowser.plist",
    "~/Library/WebKit/com.donutbrowser",
  ]
end