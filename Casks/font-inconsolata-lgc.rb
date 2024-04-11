cask "font-inconsolata-lgc" do
  version "1.5.2"
  sha256 "8711ada8ff5b34a5c3930a0c502b4fbc90b4b433d3ddfcb13313cea33bffc549"

  url "https:github.comMihailJPInconsolata-LGCreleasesdownloadLGC-#{version}InconsolataLGC-#{version}.tar.xz"
  name "Inconsolata LGC"
  desc "Inconsolata LGC is a modified version of Inconsolata with Cyrillic alphabet"
  homepage "https:github.comMihailJPInconsolata-LGC"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "InconsolataLGCInconsolata-LGC.ttf"
  font "InconsolataLGCInconsolata-LGC-Bold.ttf"
  font "InconsolataLGCInconsolata-LGC-Italic.ttf"
  font "InconsolataLGCInconsolata-LGC-BoldItalic.ttf"

  # No zap stanza required
end