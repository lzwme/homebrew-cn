cask "mongodb-realm-studio" do
  version "15.0.0"
  sha256 "f7d0e2380fc9836059107b24470b6c7066ee477b67ce71a9874f29940caa96e0"

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