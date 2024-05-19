cask "dcp-o-matic-combiner" do
  version "2.16.85"
  sha256 "cae1e55e4bd30bccc50cf4c690923969a290a5e91ae6e4585eb9cf4ed8dddca9"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-combiner&version=#{version}"
  name "DCP-o-matic-combiner"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Combiner.app"

  # No zap stanza required
end