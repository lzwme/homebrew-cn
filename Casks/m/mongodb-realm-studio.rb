cask "mongodb-realm-studio" do
  version "15.2.1"
  sha256 "cdc7af2ccd8de7055f3a7fef59db8a0bc7154eed7ddb2a3a70dc60231b7b7a58"

  url "https:github.comrealmrealm-studioreleasesdownloadv#{version}Realm.Studio-#{version}.dmg",
      verified: "github.comrealmrealm-studio"
  name "Realm Studio"
  desc "Tool for the Realm Database and Realm Platform"
  homepage "https:realm.ioproductsrealm-studio"

  auto_updates true

  app "Realm Studio.app"

  zap delete: [
    "~LibraryApplication SupportRealm Studio",
    "~LibraryCachesio.realm.realm-studio",
    "~LibraryCachesio.realm.realm-studio.ShipIt",
    "~LibraryLogsRealm Studio",
    "~LibraryPreferencesio.realm.realm-studio.helper.plist",
    "~LibraryPreferencesio.realm.realm-studio.plist",
    "~LibrarySaved Application Stateio.realm.realm-studio.savedState",
  ]

  caveats do
    requires_rosetta
  end
end