cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.1.0-beta.1"
  sha256 arm:   "fa6310e8433c28b5da7b6e1f6b7af42fd8d9afceaacc204e5f7091990f8ac479",
         intel: "7955320e57032524137d1227fd84769a3efc2f727bd2b994874b0888cdaca06a"

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