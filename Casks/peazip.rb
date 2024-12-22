cask "peazip" do
  version "10.1.0"
  sha256 "ed14c3279c8d10b67d3c850abf90ec300a38f3f5666bb67aba4d9c953411ae27"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end