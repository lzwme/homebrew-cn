cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.22.0-beta.1"
  sha256 arm:   "54a4e29863d7d19d221b7e0bd2e6530e72639714d4cda715f99165f15432ce8b",
         intel: "f6a7a8e0e5b59bfb1de695bacf5db99017c1f3abe22e470a1e0142c789c74609"

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