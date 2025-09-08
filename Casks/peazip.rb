cask "peazip" do
  version "10.6.1"
  sha256 "7229a8482ee88b465d90591d19438572a8ebaee6b5a22c781ef6d7b65916d4c2"

  url "https://ghfast.top/https://github.com/peazip/PeaZip/releases/download/#{version}/peazip-#{version}.DARWIN.x86_64.dmg"
  name "peazip"
  desc "Cross-platform file and archive manager"
  homepage "https://github.com/peazip/PeaZip"

  livecheck do
    strategy :github_releases
  end

  app "peazip.app"
end