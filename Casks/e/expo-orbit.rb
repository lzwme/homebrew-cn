cask "expo-orbit" do
  version "1.0.3"
  sha256 "060d1d27a66e2c37493eae2a22dbb99803e075a0f1a02dedf22ae27717634ca7"

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