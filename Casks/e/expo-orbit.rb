cask "expo-orbit" do
  version "2.0.3"
  sha256 "29be06087e7d3d8d7358915c8a3dacf12767975b568b766abd8ec6d21c93db63"

  url "https:github.comexpoorbitreleasesdownloadexpo-orbit-v#{version}expo-orbit.v#{version}-macos.zip"
  name "Expo Orbit"
  desc "Launch builds and start simulators from your menu bar"
  homepage "https:github.comexpoorbit"

  depends_on macos: ">= :big_sur"

  app "Expo Orbit.app"

  zap trash: [
    "~LibraryApplication Supportdev.expo.orbit",
    "~LibraryCachesdev.expo.orbit",
    "~LibraryHTTPStoragesdev.expo.orbit",
    "~LibraryPreferencesdev.expo.orbit.plist",
    "~LibraryWebKitdev.expo.orbit",
  ]
end