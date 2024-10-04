cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.28.0-beta.1"
  sha256 arm:   "bd9b8155e991c9c25ce37ac40fd803ec07be6ea862d2941a21f343eb3ff93803",
         intel: "97a6219e519ead1fdea6ab44a053d053ef1c92ed6dfa29700c21038db9bd40eb"

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