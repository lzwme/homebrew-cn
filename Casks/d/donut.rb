cask "donut" do
  arch arm: "aarch64", intel: "x64"

  version "0.22.1"
  sha256 arm:   "333dd43ed9f5a79b35a4f4e4d38dfd937a25b69cd7e3aec457ac66ca5b7725f3",
         intel: "3b65aebee543a69e758a42af9f71914bd14397864b6fa46f1a8fab5f3f03fc14"

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