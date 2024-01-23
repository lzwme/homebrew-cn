cask "aerial" do
  version "3.3.7"
  sha256 "9445903df76aeb9c50937a32af3981acd65e079f83f403af558df83a940a8352"

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
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaver.x86-64DataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaver.x86-64DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferencesByHostcom.JohnCoates.Aerial*.plist",
    "~LibraryPreferencesByHostcom.JohnCoates.Aerial*",
    "~LibraryScreen SaversAerial.saver",
  ]
end