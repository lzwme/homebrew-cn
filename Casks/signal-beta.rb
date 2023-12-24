cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.43.0-beta.4"
  sha256 arm:   "a6c73545d2554c7846338f5863b7138ece0d3f729a9a398aa847562de0db52ed",
         intel: "2e05163e01ac73b5edea18e0addaeda566ce8a5db34235ecc942ff3873c6a54f"

  url "https:updates.signal.orgdesktopsignal-desktop-beta-mac-#{arch}-#{version}.dmg"
  name "Signal Beta"
  desc "Instant messaging application focusing on security"
  homepage "https:signal.org"

  livecheck do
    url "https:github.comsignalappSignal-Desktop"
    regex(^v?(\d+(?:\.\d+)+[._-]beta\.\d+)$i)
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Signal Beta.app"

  zap trash: [
    "~LibraryApplication SupportSignal",
    "~LibraryPreferencesorg.whispersystems.signal-desktop.helper.plist",
    "~LibraryPreferencesorg.whispersystems.signal-desktop.plist",
    "~LibrarySaved Application Stateorg.whispersystems.signal-desktop.savedState",
  ]
end