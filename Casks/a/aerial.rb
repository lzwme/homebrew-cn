cask "aerial" do
  version "3.5.0"
  sha256 "c96527b7845bb5240e05e98d4adbcef0d088d92f59e88363279e86fcd3340485"

  url "https:github.comJohnCoatesAerialreleasesdownloadv#{version}Aerial.saver.zip",
      verified: "github.comJohnCoatesAerial"
  name "Aerial Screensaver"
  desc "Apple TV Aerial screensaver"
  homepage "https:aerialscreensaver.github.io"

  conflicts_with cask: "aerial@beta"
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