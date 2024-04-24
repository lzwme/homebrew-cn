cask "mongodb-realm-studio" do
  version "15.0.1"
  sha256 "d5fc16459db9167bb573632704c1b110840c40fb19fd04f91db51584378fe1ed"

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