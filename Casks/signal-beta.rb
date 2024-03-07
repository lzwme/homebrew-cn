cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.2.0-beta.1"
  sha256 arm:   "1cb0c3c7a157b3d9458874f6cd39926effb29002aa59dede9ad525149c7f582c",
         intel: "302d3c002180d7f9090fef9d0ee9bd51ba4b610f72d9a75c2ec7da283bdcbf86"

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