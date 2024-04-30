cask "aerial@beta" do
  version "3.2.7beta9"
  sha256 "ab54eb9a072ed770ee0bebec73f4537958b7ba3dcad4fba761679146096c6031"

  url "https:github.comJohnCoatesAerialreleasesdownloadv#{version}Aerial.saver.zip",
      verified: "github.comJohnCoatesAerial"
  name "Aerial Screensaver"
  desc "Apple TV Aerial screensaver"
  homepage "https:aerialscreensaver.github.io"

  livecheck do
    url "https:github.comJohnCoatesAerialreleases?q=prerelease%3Atrue&expanded=true"
    regex(^v?(\d+(?:\.\d+)*beta\d+)$i)
  end

  conflicts_with cask: "aerial"
  depends_on macos: ">= :sierra"

  screen_saver "Aerial.saver"

  zap trash: [
    "~LibraryApplication SupportAerial",
    "~LibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryPreferencesByHostcom.JohnCoates.Aerial*.plist",
    "~LibraryPreferencesByHostcom.JohnCoates.Aerial*",
    "~LibraryScreen SaversAerial.saver",
  ]
end