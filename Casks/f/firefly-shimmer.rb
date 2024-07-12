cask "firefly-shimmer" do
  version "2.1.15"
  sha256 "72d839552c21e33b9e8d2b5775d074f7dfea6a4e520e2aec27da15e68777bbeb"

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