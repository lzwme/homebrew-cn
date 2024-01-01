cask "archipelago" do
  version "6.0.2"
  sha256 "e3cefb8cabfac0e6f0b7cb47e802b8563044fda5fc05b0909c45203f34dd0388"

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