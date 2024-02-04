cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.47.0-beta.2"
  sha256 arm:   "b5712ef8d0e2a771b35d25462c2e7f2436dbb51b4425b78fba986ce8a2a46eb3",
         intel: "e4d53c2e3f1bb42e20a4ad4415366a990edec2586212304adca90090612e297b"

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