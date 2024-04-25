cask "dcp-o-matic" do
  version "2.16.81"
  sha256 "85c4e1c21a2d93d844612ceaac7137143285b379233f7c65e9185051f4d6188a"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-main&version=#{version}"
  name "DCP-o-matic"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    url "https://dcpomatic.com/download"
    regex(/stable\s*release:\s*(\d+(?:\.\d+)+)/i)
  end

  app "DCP-o-matic #{version.major}.app"

  # No zap stanza required
end