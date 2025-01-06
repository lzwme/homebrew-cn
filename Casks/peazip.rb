cask "peazip" do
  version "10.2.0"
  sha256 "66835755439a952631f6b3271d31a264402e0d77245f9a3fd21a118be2d8d3ac"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end