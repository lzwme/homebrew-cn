cask "archipelago" do
  version "6.0.3"
  sha256 "003a6486536d6baf56659ed2db7fd1452da01361b6bb72871f36e30be8c068ea"

  url "https:github.comnpezza93archipelagoreleasesdownloadv#{version}Archipelago.zip"
  name "Archipelago"
  desc "Terminal emulator built on web technology"
  homepage "https:github.comnpezza93archipelago"

  depends_on macos: ">= :sonoma"

  app "Archipelago.app"

  zap trash: [
    "~LibraryApplication SupportArchipelago",
    "~LibraryCachesdev.archipelago",
    "~LibraryCachesdev.archipelago.ShipIt",
    "~LibraryHTTPStoragesdev.archipelago",
    "~LibraryPreferencesdev.archipelago.plist",
    "~LibrarySaved Application Statedev.archipelago.savedState",
    "~LibraryWebKitdev.archipelago",
  ]
end