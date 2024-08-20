cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.21.0-beta.2"
  sha256 arm:   "1b1419cc166e1c1efb9341aeb7701641c3426c9334c5206d91ed6d631aea2533",
         intel: "a23360ef04cfe7b89c708f2b490e99b6d886d6df4085acae259e13a7f941c9f7"

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