cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.23.0-beta.1"
  sha256 arm:   "7026446d5a33d9437a9f1906e6797b3b92e360c262893c924feb640adb72ee27",
         intel: "924b4d72c8d5c9656d862820b6f6ec70bfdb7beeaf2507c3e3d0c6e1869240bb"

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