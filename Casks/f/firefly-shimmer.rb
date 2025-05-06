cask "firefly-shimmer" do
  version "2.2.0"
  sha256 "0d1f1780d79679b5140ef04b7699eeb3439382fb456e865ae07c7ce321e7533b"

  url "https:github.comiotaledgerfireflyreleasesdownloaddesktop-shimmer-#{version}firefly-shimmer-desktop-#{version}.dmg",
      verified: "github.comiotaledgerfirefly"
  name "Firefly Shimmer"
  desc "Official wallet for IOTA"
  homepage "https:firefly.iota.org"

  livecheck do
    url "https:dl.firefly.iota.orgshimmer-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Firefly Shimmer.app"

  uninstall quit: "org.iota.firefly"

  zap trash: [
    "~LibraryApplication SupportFirefly",
    "~LibraryLogsFirefly",
    "~LibraryPreferencesorg.iota.firefly.helper.plist",
    "~LibraryPreferencesorg.iota.firefly.plist",
    "~LibrarySaved Application Stateorg.iota.firefly.savedState",
  ]

  caveats do
    requires_rosetta
  end
end