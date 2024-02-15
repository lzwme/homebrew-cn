cask "signal-beta" do
  arch arm: "arm64", intel: "x64"

  version "6.48.0-beta.2"
  sha256 arm:   "ecc39e82b7021f6cb2a74697d050122443d3dfef127522fa78b775a0d90c6ec7",
         intel: "9f19dcdac56cc80238b66c82a2228e6c481fa880bae913a76cfda9c4c1cb7e92"

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