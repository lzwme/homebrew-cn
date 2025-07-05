cask "peazip" do
  version "10.5.0"
  sha256 "49e365c7e71dc74e27d97f5bb73a2312a9b97ee4278e1032fe7f4f4080a9cdc3"

  url "https://ghfast.top/https://github.com/peazip/PeaZip/releases/download/#{version}/peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https://github.com/peazip/PeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end