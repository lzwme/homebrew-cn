cask "peazip" do
  version "9.7.1"
  sha256 "f1440ada8dd8be88b71c3e2788e1526ee845c619a4070dd3ac3fddef4e84020c"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end