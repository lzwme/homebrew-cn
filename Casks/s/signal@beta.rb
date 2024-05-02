cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.8.0-beta.1"
  sha256 arm:   "bef43551412870160940f12929fdb686768fce1a8a479bb206b434dea3d63fd7",
         intel: "5271424e59aadaa52984602560901a758ae73a5acf925cebb04b95f9a02e748d"

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