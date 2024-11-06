cask "expo-orbit" do
  version "1.2.1"
  sha256 "5b17cf8e6f4ac2de581ba531ac33f3a7ba3ecba7e7c5de9dbe75554ed71c65e0"

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