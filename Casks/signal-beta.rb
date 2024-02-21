cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.0.0-beta.1"
  sha256 arm:   "8e71a6eb0fd2307848e6640e8333d2fdd2492f7ec0df4a9adbaaf278a3b25a28",
         intel: "a435cfada7e5a2234de3ea6dc90c95824e7c5505493db982912584e834bbcb82"

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