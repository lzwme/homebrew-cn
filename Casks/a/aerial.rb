cask "aerial" do
  version "3.3.5"
  sha256 "69f2db4c75e0f7cad34ff1b3f3ebdf3f6714024c064894c6ac1795f1d4608c02"

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