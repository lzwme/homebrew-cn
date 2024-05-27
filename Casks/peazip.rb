cask "peazip" do
  version "9.8.0"
  sha256 "ccb608ea543ba29dc6b992537d144475ab21f68ec03abd8a78b728cf0aaebf5e"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end