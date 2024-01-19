cask "aerial" do
  version "3.3.6"
  sha256 "6f920dd293c67c416abf4a1ec893d5df731eb582f3d6dea7f3c270b169be16f0"

  url "https:github.comJohnCoatesAerialreleasesdownloadv#{version}Aerial.saver.zip",
      verified: "github.comJohnCoatesAerial"
  name "Aerial Screensaver"
  desc "Apple TV Aerial screensaver"
  homepage "https:aerialscreensaver.github.io"

  conflicts_with cask: "homebrewcask-versionsaerial-beta"
  depends_on macos: ">= :sierra"

  screen_saver "Aerial.saver"

  zap trash: [
    "~LibraryApplication SupportAerial",
    "~LibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaver.x86-64DataLibrary" \
    "Application SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaver.x86-64DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferences" \
    "ByHostcom.JohnCoates.Aerial*.plist",
    "~LibraryPreferencesByHostcom.JohnCoates.Aerial*",
    "~LibraryScreen SaversAerial.saver",
  ]
end