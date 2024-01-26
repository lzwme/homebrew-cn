cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.46.0-beta.1"
  sha256 arm:   "754074678890c74d50f28c42b14a21ac25fdea2ccba98a45140b5d54e5281db3",
         intel: "dc85283b41c7781bb05ece2a93462d76334f5b947cf2844ccdb7acab5b9ab483"

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