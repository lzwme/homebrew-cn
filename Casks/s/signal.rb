cask "signal" do
  arch arm: "arm64", intel: "x64"

  version "7.5.0"
  sha256 arm:   "c17d6b7a13b82c95a3a162372a48122495df1fc09d7e6608c4cb64dc1896bccf",
         intel: "79de8e71a48133b1e1af1465bc577e4d6708dbfb57bfa2ac109af996ff75958c"

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