cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "8.9.0-beta.1"
  sha256 arm:   "1a320b8bab85a83687dd25edd43a1762a238fddb26af2ea0d96ca75f052333ac",
         intel: "e20114ad56f77036da7abd18456a474b86778a724113cc4642ed79052eec7d5f"

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