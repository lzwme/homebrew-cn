cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.48.0-beta.1"
  sha256 arm:   "fe6b09a50247186a0db41c8f409f17b6f0eb483deaf158aab96cc48e3b59bbd0",
         intel: "2d03fe60b3eaf83c11f88e2b1d23eeb07ad0c0d2b493c3b4ba843c37ef60ab28"

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