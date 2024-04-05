cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.5.0-beta.1"
  sha256 arm:   "3ac5b7ca3f695b783503a0f3d36929177654f43ae18e9a72fc49a42cfca2d6ac",
         intel: "934384fd1e20a55c26d579bd8e18de288e7503a6a2d6b951eef035fc497740ff"

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