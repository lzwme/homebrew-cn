cask "expo-orbit" do
  version "1.0.1"
  sha256 "17268d54fc531eb56ad669033597a6a8eb290296ec81ed8de64eb2f85295de53"

  url "https:github.comexpoorbitreleasesdownloadexpo-orbit-v#{version}expo-orbit.v#{version}.zip"
  name "Expo Orbit"
  desc "Launch builds and start simulators from your menu bar"
  homepage "https:github.comexpoorbit"

  depends_on macos: ">= :catalina"

  app "Expo Orbit.app"

  zap trash: [
    "~LibraryApplication Supportdev.expo.orbit",
    "~LibraryCachesdev.expo.orbit",
    "~LibraryHTTPStoragesdev.expo.orbit",
    "~LibraryPreferencesdev.expo.orbit.plist",
    "~LibraryWebKitdev.expo.orbit",
  ]
end