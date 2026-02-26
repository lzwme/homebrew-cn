cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "8.1.0-beta.1"
  sha256 arm:   "40a24def6f6ad180ea9c65e362b10266df63ce2914c442b956e9048d053fdaca",
         intel: "5500aa69ab3ad5b1df3cb322787a3e6c245f66d3d7003ea22afed7927097eafe"

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