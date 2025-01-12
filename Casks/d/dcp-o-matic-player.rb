cask "dcp-o-matic-player" do
  version "2.18.3"
  sha256 "027454807e28ae862fe7b89101d554e1e5f0552cabbc69e30312069951101ee7"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-player&version=#{version}"
  name "DCP-o-matic Player"
  desc "Play Digital Cinema Packages"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Player.app"

  # No zap stanza required
end