cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.2.0-beta.2"
  sha256 arm:   "80ae40befcd339a8f23d21e2172f2f11bc7a1ffcce52b35784a97efb317730c3",
         intel: "a156f5a2b7a4f1b3cef7f003573523a5743888863c6fa2523be129a82c247c77"

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