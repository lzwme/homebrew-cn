cask "signal@beta" do
  arch arm: "arm64", intel: "x64"

  version "7.12.0-beta.3"
  sha256 arm:   "6b4cd8883f818898768fe88909436a26bc310a3bcea8fb2a7e177a18ec3adab2",
         intel: "dba8f889d821f2fc0012186e662d7bf373c02fef613328d46b96525ff75fe40e"

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