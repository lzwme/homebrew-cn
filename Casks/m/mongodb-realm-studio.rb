cask "mongodb-realm-studio" do
  version "15.1.1"
  sha256 "76cb3b2b5e596ccbe6a5ccd89042c3fe92e2d65f9985d08f5579810d3929c51a"

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
end