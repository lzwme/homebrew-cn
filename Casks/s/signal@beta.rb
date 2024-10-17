cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.30.0-beta.1"
  sha256 arm:   "4196fc7cc88dd236294fc34dc607f0f3caaf3e950debb3259727e5e803c4b7ec",
         intel: "75c23ef078a316a86e1fe7b9799a95d799df0457f4f84f49073fc847528f3e9d"

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