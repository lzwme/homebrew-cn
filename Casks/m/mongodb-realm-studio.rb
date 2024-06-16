cask "mongodb-realm-studio" do
  version "15.2.0"
  sha256 "95782d576267025bf6527819f9f5bc70b34dfbe96e85f47e465c2aedc295338d"

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