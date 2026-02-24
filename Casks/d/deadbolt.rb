cask "deadbolt" do
  arch arm: "-arm64"

  version "2.1.0"
  sha256 arm:   "0469c775850f3199a0b34394aaa5af5f46766420b341e27eee698ac0c0d3dde7",
         intel: "6ce5e4bab48ae0eb48523b9c00f76b5cf7c89eeb60bf43d1be7fb570126e790a"

  url "https://ghfast.top/https://github.com/alichtman/deadbolt/releases/download/v#{version}/Deadbolt-#{version}#{arch}.dmg"
  name "Deadbolt"
  desc "File encryption tool"
  homepage "https://github.com/alichtman/deadbolt"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Deadbolt.app"

  zap trash: [
    "~/Library/Application Support/deadbolt",
    "~/Library/Preferences/org.alichtman.deadbolt.plist",
    "~/Library/Saved Application State/org.alichtman.deadbolt.savedState",
  ]
end