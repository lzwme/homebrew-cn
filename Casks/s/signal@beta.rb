cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.36.0-beta.1"
  sha256 arm:   "97947cdea8903c82696db940b31f707cdd63038e5b6f952f0ccc3ff41f9e43c2",
         intel: "c614d528c7d36bab5d000b3561f3faf198ab7ee98a7a6e759abb11f68bed86e7"

  url "https:updates.signal.orgdesktopsignal-desktop-beta-mac-#{arch}-#{version}.dmg"
  name "Signal Beta"
  desc "Instant messaging application focusing on security"
  homepage "https:signal.org"

  livecheck do
    url "https:github.comsignalappSignal-Desktop"
    regex(^v?(\d+(?:\.\d+)+[._-]beta\.\d+)$i)
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Signal Beta.app"

  zap trash: [
    "~LibraryApplication SupportSignal",
    "~LibraryPreferencesorg.whispersystems.signal-desktop.helper.plist",
    "~LibraryPreferencesorg.whispersystems.signal-desktop.plist",
    "~LibrarySaved Application Stateorg.whispersystems.signal-desktop.savedState",
  ]
end