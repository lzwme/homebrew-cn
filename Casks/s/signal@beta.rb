cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.30.0-beta.2"
  sha256 arm:   "c1bb0f9a65804704d6e4ea4b28bccf397b29ccc61689a2f04595f6f1cc7e4b71",
         intel: "a149a4c5d2e16c1765c830532101d67556e6b171cc7ebbf753735eb7e9d4c146"

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