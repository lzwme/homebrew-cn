cask "dcp-o-matic-editor" do
  version "2.18.5"
  sha256 "e9168d87fbee682d6eb5e49792cfc0413622a3ed7ebcda422378d427782cbd35"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-editor&version=#{version}"
  name "DCP-o-matic Editor"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Editor.app"

  # No zap stanza required
end