cask "font-simple-line-icons" do
  version "2.5.4"
  sha256 "1b0b4f39c0ed88e5507548bfeac01b1177804941ec687195ad551a7ce690b24d"

  url "https:github.comthesabbirsimple-line-iconsarchiverefstags#{version}.tar.gz",
      verified: "github.comthesabbirsimple-line-icons"
  name "Simple Line Icons"
  homepage "https:simplelineicons.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "simple-line-icons-#{version}fontsSimple-Line-Icons.ttf"

  # No zap stanza required
end