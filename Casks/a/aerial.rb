cask "aerial" do
  version "3.3.8"
  sha256 "457804fd7ba8959d353908aeae27fc998d5379033970b59a2afe60434623c44d"

  url "https:github.comJohnCoatesAerialreleasesdownloadv#{version}Aerial.saver.zip",
      verified: "github.comJohnCoatesAerial"
  name "Aerial Screensaver"
  desc "Apple TV Aerial screensaver"
  homepage "https:aerialscreensaver.github.io"

  conflicts_with cask: "aerial-beta"
  depends_on macos: ">= :sierra"

  screen_saver "Aerial.saver"

  zap trash: [
    "~LibraryApplication SupportAerial",
    "~LibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaver.x86-64DataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaver.x86-64DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferencesByHostcom.JohnCoates.Aerial*.plist",
    "~LibraryPreferencesByHostcom.JohnCoates.Aerial*",
    "~LibraryScreen SaversAerial.saver",
  ]
end