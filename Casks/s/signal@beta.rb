cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.25.0-beta.2"
  sha256 arm:   "441cd5c42ae61b310ac730687e4a1d93e8904dc9cf3be19221096a76b908d442",
         intel: "11a40d28866d9fcba8cb3f466b6a1d1d24c67263fa6f1004c5693949b6eac945"

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