cask "pd-l2ork" do
  version "2.19.3"
  sha256 "c0ffc0cd92295376e880455d3e69d1c7382f03093de0602a201846608ac007d3"

  url "https:github.comagraefpurr-datareleasesdownload#{version.csv.first}purr-data-#{version.csv.first}-macos-x86_64.zip",
      verified: "github.comagraefpurr-data"
  name "Pd-l2ork"
  name "Purr Data"
  desc "Programming environment for computer music and multimedia applications"
  homepage "https:agraef.github.iopurr-data"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Purr-Data.app"
  binary "#{appdir}Purr-Data.appContentsResourcesapp.nwbinpd-l2ork"

  uninstall_preflight do
    set_permissions "#{appdir}Purr-Data.app", "0777"
  end

  zap trash: [
    "~LibraryApplication SupportPurr-Data",
    "~LibraryLogsPurr-Data",
    "~LibraryPurr-Data",
  ]
end