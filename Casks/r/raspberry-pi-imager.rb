cask "raspberry-pi-imager" do
  version "1.8.4"
  sha256 "c5c31067f01ef9a5d8303aa557cd7623b0216f2e1051da1b32ed2eef8c70f430"

  url "https:github.comraspberrypirpi-imagerreleasesdownloadv#{version}Raspberry.Pi.Imager.#{version}.dmg",
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