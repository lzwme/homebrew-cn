cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "8.9.0-beta.2"
  sha256 arm:   "460fd8c5b72c724f15a80b80fd611dd6281a7b4999f3dd7f866fb6e1da0d92ad",
         intel: "0bad930b2ca9609516f424e9b52f41c04f868e5bff006e8e62483533c96a2e82"

  url "https://updates.signal.org/desktop/signal-desktop-beta-mac-#{arch}-#{version}.zip"
  name "Signal Beta"
  desc "Instant messaging application focusing on security"
  homepage "https://signal.org/"

  livecheck do
    url "https://updates.signal.org/desktop/beta-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Signal Beta.app"

  zap trash: [
    "~/Library/Application Support/Signal",
    "~/Library/Preferences/org.whispersystems.signal-desktop.helper.plist",
    "~/Library/Preferences/org.whispersystems.signal-desktop.plist",
    "~/Library/Saved Application State/org.whispersystems.signal-desktop.savedState",
  ]
end