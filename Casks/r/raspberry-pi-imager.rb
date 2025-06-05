cask "raspberry-pi-imager" do
  version "1.9.4"
  sha256 "949099a55aa97b380e3b9c24ec02e6fdb9a5b7e57257720fe3d9cf6190e110be"

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