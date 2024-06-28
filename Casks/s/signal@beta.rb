cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.15.0-beta.1"
  sha256 arm:   "9dd2b9ff6d9de3f6e1ddb93bfc6855651d7fcb297c6a69c0230afc18d31c7a0b",
         intel: "52fe6bf2dc0446e64e62f0124d854084358736e0308079bb38da85b300b404d7"

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