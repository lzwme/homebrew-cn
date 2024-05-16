cask "gns3" do
  # NOTE: "3" is not a version number, but an intrinsic part of the product name
  version "2.2.47"
  sha256 "dbb1d540501adb58589c2e9c985ce2f839dc08afa9378637966e9577b291e22c"

  url "https:github.comGNS3gns3-guireleasesdownloadv#{version}GNS3-#{version}.dmg",
      verified: "github.comGNS3gns3-gui"
  name "GNS3"
  name "Graphical Network Simulator 3"
  desc "GUI for the Dynamips Cisco router emulator"
  homepage "https:www.gns3.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "GNS3.app"

  zap trash: [
    "~GNS3",
    "~LibrarySaved Application Statenet.gns3.savedState",
  ]
end