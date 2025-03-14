cask "dcp-o-matic-disk-writer" do
  version "2.18.13"
  sha256 "aee6f0ad5adb7fd99f0a974f94b70204bd4938018ffa1aa2e7a8272c970a194b"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-disk&version=#{version}"
  name "DCP-o-matic Disk Writer"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Disk Writer.app"

  # No zap stanza required
end