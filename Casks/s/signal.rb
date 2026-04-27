cask "signal" do
  arch arm: "arm64", intel: "x64"

  version "8.8.0"
  sha256 arm:   "8ffa773d8275230c0a64ffa1ff20ebd8872b27adfb1c747f013b0fd2d5b316e5",
         intel: "6097714a15d5fd2db8523d1854c546db1a953095f6a5daf6bf30a3b8b8ab1461"

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