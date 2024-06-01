cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.12.0-beta.2"
  sha256 arm:   "5eee7be409264cce4a780826c532b4f9f46e34cbe85e2ceddf6702b000134dca",
         intel: "101f1dfa7e1f8cfdfee43e18077a3375e0055006b5e35567c297e623a7ec21b0"

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