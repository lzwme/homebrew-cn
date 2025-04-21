cask "peazip" do
  version "10.4.0"
  sha256 "0a7058c9cabc4be43809a55092c3f1f5fc3bc4bc2a3e7c275ed21a25a0c6d556"

  url "https:github.compeazipPeaZipreleasesdownload#{version}peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https:github.compeazipPeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end