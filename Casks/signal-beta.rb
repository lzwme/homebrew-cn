cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.43.0-beta.2"
  sha256 arm:   "7a1f9b166a4c1ef3cfc5ca4cf2364b8c348dc9dcdae32d1b5a372de62989c780",
         intel: "fc316dfc57b8578c9693de481c108c61b87217e0dee51671a754b416a75aac9b"

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