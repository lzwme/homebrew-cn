cask "peazip" do
  version "10.7.0"
  sha256 "2857d3774d8e24c0d35f9c034cf127c333da01dbd63d180d25e89cb46cb21845"

  url "https://ghfast.top/https://github.com/peazip/PeaZip/releases/download/#{version}/peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https://github.com/peazip/PeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end