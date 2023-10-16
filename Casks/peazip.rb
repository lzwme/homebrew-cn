cask "peazip" do
  version "9.4.0"
  sha256 "0892e81c36b643a76cf6fbea5f767bbbe395cd11a58beff9a34d2be437b2f88b"

  url "https://ghproxy.com/https://github.com/peazip/PeaZip/releases/download/#{version}/peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https://github.com/peazip/PeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end