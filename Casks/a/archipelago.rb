cask "archipelago" do
  version "6.0.8"
  sha256 "58e394886db7e5a32feeb48d7b78951ee230689bf79279e67f79c881df42bb1f"

  url "https:github.comnpezza93archipelagoreleasesdownloadv#{version}Archipelago.zip"
  name "Archipelago"
  desc "Terminal emulator built on web technology"
  homepage "https:github.comnpezza93archipelago"

  depends_on macos: ">= :sequoia"

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