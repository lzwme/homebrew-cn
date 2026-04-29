cask "athas" do
  arch arm: "aarch64", intel: "x64"

  version "0.4.7"
  sha256 arm:   "2b85c933bedd15c3e5c0fff2cd53befd82482058f5c516457a90304bf77e686e",
         intel: "85ee1a316ea0b8ac4c25a3fa30120e1f84ccbf232a69601dc306bb549db60d1b"

  url "https://ghfast.top/https://github.com/athasdev/athas/releases/download/v#{version}/Athas_#{version}_#{arch}.dmg",
      verified: "github.com/athasdev/athas/"
  name "Athas"
  desc "Lightweight code editor"
  homepage "https://athas.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Athas.app"

  zap trash: [
    "~/Library/Application Support/com.code.athas",
    "~/Library/Caches/com.code.athas",
    "~/Library/Logs/com.code.athas",
    "~/Library/Preferences/com.code.athas.plist",
    "~/Library/WebKit/com.code.athas",
  ]
end