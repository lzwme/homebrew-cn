cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.37.0-beta.1"
  sha256 arm:   "1bac52b84282a6725b1aba30a2f2de090e09a9fd6c3daca51b0ced60508e8f77",
         intel: "91b5a80e88159064999482ee110cf519d6746d076dd48fe7fe0a4ca868ce83ff"

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