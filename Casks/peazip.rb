cask "peazip" do
  version "9.6.0"
  sha256 "d1cd6d0e0bd2b2e7e63085c3bdd3ec4d851aecaef0991ead302913b1e3e925cb"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end