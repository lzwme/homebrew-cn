cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.2.0-beta.3"
  sha256 arm:   "4f53959796d081c12e8e7c83c81915ef8366c7607b6cb1803fcf3988f9043d8c",
         intel: "138058e8f143876605e1130b889ebf6fd994924441cacc0778a5fafa06fcb5bf"

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