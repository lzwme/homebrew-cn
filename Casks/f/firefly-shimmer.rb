cask "firefly-shimmer" do
  version "2.1.10"
  sha256 "14987060bda75dc5c70c13d832299bb9d20c2e7c934090a6d3f4070d39d336ba"

  url "https:github.comiotaledgerfireflyreleasesdownloaddesktop-shimmer-#{version}firefly-shimmer-desktop-#{version}.dmg",
      verified: "github.comiotaledgerfirefly"
  name "Firefly Shimmer"
  desc "Official wallet for IOTA"
  homepage "https:firefly.iota.org"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Firefly Shimmer.app"

  uninstall quit: "org.iota.firefly"

  zap trash: [
    "~LibraryApplication SupportFirefly",
    "~LibraryLogsFirefly",
    "~LibraryPreferencesorg.iota.firefly.helper.plist",
    "~LibraryPreferencesorg.iota.firefly.plist",
    "~LibrarySaved Application Stateorg.iota.firefly.savedState",
  ]
end