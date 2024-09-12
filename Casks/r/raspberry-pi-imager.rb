cask "raspberry-pi-imager" do
  version "1.9.0"
  sha256 "c397823864f22eab694f2160a9e92debc1b439a2bece744545ca8dafda39eaae"

  url "https:github.comraspberrypirpi-imagerreleasesdownloadv#{version}Raspberry.Pi.Imager-#{version}.dmg",
      verified: "github.comraspberrypirpi-imager"
  name "Raspberry Pi Imager"
  desc "Imaging utility to install operating systems to a microSD card"
  homepage "https:www.raspberrypi.orgdownloads"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Raspberry Pi Imager.app"

  zap trash: [
    "~LibraryCachesRaspberry Pi",
    "~LibraryPreferencesorg.raspberrypi.Imager.plist",
    "~LibrarySaved Application Stateorg.raspberrypi.imagingutility.savedState",
  ]
end