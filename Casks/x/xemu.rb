cask "xemu" do
  version "0.8.103"
  sha256 "a5f3e8b11b83c6990d3271dc0a778a8ecf672f28926516f1307276cfc05a4a2e"

  url "https://ghfast.top/https://github.com/xemu-project/xemu/releases/download/v#{version}/xemu-macos-universal-release.zip",
      verified: "github.com/xemu-project/xemu/"
  name "Xemu"
  desc "Original Xbox Emulator"
  homepage "https://xemu.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Xemu.app"

  zap trash: [
    "~/Library/Application Support/xemu",
    "~/Library/Preferences/xemu.app.0.plist",
    "~/Library/Saved Application State/xemu.app.0.savedState",
  ]
end