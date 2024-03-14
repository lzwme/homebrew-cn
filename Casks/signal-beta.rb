cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "7.3.0-beta.1"
  sha256 arm:   "ba6999d6058cd8e6944fad35f77bc92cf0c54b7785b3b8bf81df061642485cfd",
         intel: "729ccfefa228b3cf3fd35eaeab531ef5db49484b08ee770ebc8acc9cb208eaae"

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