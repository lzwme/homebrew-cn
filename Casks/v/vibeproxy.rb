cask "vibeproxy" do
  arch arm: "arm64", intel: "x86_64"

  version "1.8.290"
  sha256 arm:   "1267501e3589fc02843754e6fcfe94c256789cbf52a596626609cbd8a4fb1195",
         intel: "0450c4f4a0f89b682aaddc5cd498535b5533193a8eb1219687c2ec89b5284bef"

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