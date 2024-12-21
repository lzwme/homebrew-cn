cask "gns3" do
  # NOTE: "3" is not a version number, but an intrinsic part of the product name
  version "3.0.0"
  sha256 "f1ffef8cff6110c2efc3e390e0ea8c26b72621c0d3261f1977e887c5cd838f39"

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

  depends_on macos: ">= :monterey"

  app "GNS3.app"

  zap trash: [
    "~GNS3",
    "~LibrarySaved Application Statenet.gns3.savedState",
  ]
end