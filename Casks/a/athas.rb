cask "athas" do
  arch arm: "aarch64", intel: "x64"

  version "0.5.1"
  sha256 arm:   "9b2121ec5e1c61e62c7d2408128a397c014a515384de4ad62c4ad20b74d00742",
         intel: "d62a2c1ec01066bc837e7ad05ff7747dec07fdee0112d186c5d6dcc34d999139"

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