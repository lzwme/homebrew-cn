cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.43.0-beta.3"
  sha256 arm:   "a1b17a4cd92a78b645358a0c142c087f2eb3614aa76851f6b5d7ec1d67303fc9",
         intel: "58ef6b275b522d056ad3c994a46c7c6ea10e545e7ff8a10bb7803b10412afad4"

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