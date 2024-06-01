cask "dcp-o-matic-editor" do
  version "2.16.86"
  sha256 "f562fd5b922f45450e8e23d058fe25a5055b5b1a7b9e95314e4d953d2a2771f1"

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