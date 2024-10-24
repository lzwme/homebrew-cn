cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.31.0-beta.1"
  sha256 arm:   "ed565de676379d772efeabe577254f96c1f26ddb8cc312a1321ea25b8d8a9e2a",
         intel: "257cb681450917c66f46f11df981d4328225d21c93aa8cff4df5fc58b4816e20"

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