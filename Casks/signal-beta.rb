cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.6.0-beta.3"
  sha256 arm:   "95f2a34888ccaac032129ca6a8ac500d7cd954fe3947cf2d34a36d2b68dfd6db",
         intel: "581bd642a032e7e738eb4ebf279d9ec6ced3746de1fda4c4c7af11126494f72b"

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