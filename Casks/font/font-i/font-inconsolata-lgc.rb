cask "font-inconsolata-lgc" do
  version "1.12.0"
  sha256 "2995129a5211d686276db10c662132a4d39ea1ee698cdd1ebd2f2cc6a6866367"

  url "https:github.comMihailJPInconsolata-LGCreleasesdownloadLGC-#{version}InconsolataLGC-#{version}.tar.xz"
  name "Inconsolata LGC"
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