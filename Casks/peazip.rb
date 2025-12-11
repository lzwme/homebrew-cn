cask "peazip" do
  version "10.8.0"
  sha256 "812e9392e9a2da71969ba356956d6fd4936fa546de73912351b6e64cc477ac54"

  url "https://ghfast.top/https://github.com/peazip/PeaZip/releases/download/#{version}/peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https://github.com/peazip/PeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end