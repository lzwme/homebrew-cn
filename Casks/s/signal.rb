cask "signal" do
  arch arm: "arm64", intel: "x64"

  version "8.0.0"
  sha256 arm:   "6f8aaf909178aa63dcd282a47fb32355c011b0d83654187ad38b0ef3a0c58c4a",
         intel: "0ac2bef4360efa13d77872571d637748fad04f2ea2c6b791262ab861cb0ff1a2"

  url "https://updates.signal.org/desktop/signal-desktop-mac-#{arch}-#{version}.zip"
  name "Signal"
  desc "Instant messaging application focusing on security"
  homepage "https://signal.org/"

  livecheck do
    url "https://updates.signal.org/desktop/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Signal.app"

  zap trash: [
    "~/Library/Application Support/Signal",
    "~/Library/Preferences/org.whispersystems.signal-desktop.helper.plist",
    "~/Library/Preferences/org.whispersystems.signal-desktop.plist",
    "~/Library/Saved Application State/org.whispersystems.signal-desktop.savedState",
  ]
end