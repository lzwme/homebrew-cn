cask "peazip" do
  version "9.5.0"
  sha256 "db7c351efa3f464898c79a90986e043b980ad35412ae22f8f2ec34678f11a1f4"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end