cask "pd-l2ork" do
  version "2.20.0"
  sha256 "2592eb36a2387c7a357cb942b1b895e6201f3ec28b97e29070475b7ed6ba26f5"

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

  caveats do
    requires_rosetta
  end
end