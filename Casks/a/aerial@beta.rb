cask "aerial@beta" do
  version "3.5.2beta1"
  sha256 "a3e93220101065c617331162303ef79002cabb49bab3c158d5530e538eb391a0"

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