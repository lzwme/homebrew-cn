cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.19.0-beta.1"
  sha256 arm:   "7f7bb3f3fd47a4dca1215f89ec5ab68306c034d353e6fc2fa65178bcdda70ccd",
         intel: "a092f4c0e85ae85b38d8f1c3f9b53c515cd2e2d9b6631713daf00d9e0760e1bf"

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