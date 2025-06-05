cask "signal" do
  arch arm: "arm64", intel: "x64"

  version "7.56.1"
  sha256 arm:   "11b41421bf12d52fc4faf0abdf930be78ce2ac6b104854e395e5c40befbdb86b",
         intel: "96d100842da514e064270205d7204937d268056206b0665d77bff6109b2caf89"

  url "https://updates.signal.org/desktop/signal-desktop-mac-#{arch}-#{version}.zip"
  name "Signal"
  desc "Instant messaging application focusing on security"
  homepage "https://signal.org/"

  livecheck do
    url "https://updates.signal.org/desktop/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Signal.app"

  zap trash: [
    "~/Library/Application Support/Signal",
    "~/Library/Preferences/org.whispersystems.signal-desktop.helper.plist",
    "~/Library/Preferences/org.whispersystems.signal-desktop.plist",
    "~/Library/Saved Application State/org.whispersystems.signal-desktop.savedState",
  ]
end