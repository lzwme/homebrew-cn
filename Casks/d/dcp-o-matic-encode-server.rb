cask "dcp-o-matic-encode-server" do
  version "2.18.12"
  sha256 "d88c4032d998849c37efd5623bb5a1e41afe4dcfc649270dfb94e0b8addc5d4f"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-server&version=#{version}"
  name "DCP-o-matic Encode Server"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Encode Server.app"

  # No zap stanza required
end