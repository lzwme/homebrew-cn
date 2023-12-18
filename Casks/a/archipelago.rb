cask "archipelago" do
  version "6.0.0"
  sha256 "4aedc721c4d5a607ad0a068b7530567ec5897463709711fb93f50fbd4cd22932"

  url "https:github.comnpezza93archipelagoreleasesdownloadv#{version}Archipelago.zip"
  name "Archipelago"
  desc "Terminal emulator built on web technology"
  homepage "https:github.comnpezza93archipelago"

  depends_on macos: ">= :high_sierra"

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