cask "raspberry-pi-imager" do
  version "1.8.3"
  sha256 "e3597de68153f0cac8b2a5bf1938fcdfe3bd8cedc3d87fec96d1aa6c8b997c4c"

  url "https:github.comraspberrypirpi-imagerreleasesdownloadv#{version}Raspberry.Pi.Imager.#{version}-UNIVERSAL-BUILD.dmg",
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