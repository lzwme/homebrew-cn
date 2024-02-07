cask "firefly-shimmer" do
  version "2.1.12"
  sha256 "e1110d1ad32009794021e30bfa7e6a6701cde304abd05852e058767e4ee8ece3"

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