cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.16.0-beta.1"
  sha256 arm:   "abc8a72fc2db20f957f78edd73067a875398c5bf47b872a3bf3d2bd44a55c825",
         intel: "c6d131c0b5facc9645cf7949daea22658c4b424f22bf15bee22080f1ec9618ad"

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