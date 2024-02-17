cask "dcp-o-matic-combiner" do
  version "2.16.76"
  sha256 "17c478895d6e0b23d043ef064a31d6a97400da3df3cd37a86293534a72c76d3c"

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