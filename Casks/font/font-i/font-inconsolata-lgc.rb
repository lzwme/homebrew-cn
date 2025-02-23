cask "font-inconsolata-lgc" do
  version "1.11.0"
  sha256 "e87a50059da0193e04911a27a4b581457148ceb0c1cc0741d7abc807429dfe51"

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