cask "signal" do
  arch arm: "arm64", intel: "x64"

  version "7.25.0"
  sha256 arm:   "8aa1c7ba1b4daf65b994d3dfb157765f19ca16146600da391b9d196b9caa2bca",
         intel: "a12f64d97718e15f29c33bc9bb6de7d9c1a4e959e2a714fe4368fb68121b7540"

  url "https://updates.signal.org/desktop/signal-desktop-mac-#{arch}-#{version}.dmg"
  name "Signal"
  desc "Instant messaging application focusing on security"
  homepage "https://signal.org/"

  livecheck do
    url "https://updates.signal.org/desktop/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Signal.app"

  zap trash: [
    "~/Library/Application Support/Signal",
    "~/Library/Preferences/org.whispersystems.signal-desktop.helper.plist",
    "~/Library/Preferences/org.whispersystems.signal-desktop.plist",
    "~/Library/Saved Application State/org.whispersystems.signal-desktop.savedState",
  ]
end