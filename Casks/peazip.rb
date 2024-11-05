cask "peazip" do
  version "10.0.0"
  sha256 "8b17b71dbfedfe329af4ebb6cd9f39d571f2f3cf211226502e5af22ce233f1e0"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end