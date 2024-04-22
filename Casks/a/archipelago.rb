cask "archipelago" do
  version "6.0.4"
  sha256 "e7dd0b63c8c159b69df5b6baeb75aab63cad1f774570b28ff0dd1b4159f6aa60"

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