cask "firefly-shimmer" do
  version "2.1.13"
  sha256 "7dfa56937df3a15f707ed8279409acfafae377a832186783f0232cb41d2cf914"

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