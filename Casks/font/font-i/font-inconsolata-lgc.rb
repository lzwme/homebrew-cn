cask "font-inconsolata-lgc" do
  version "1.13.2"
  sha256 "e4937fb1c0a5ed0b99d4368dcafa6ea4e465967e3e83c60962370755f7ac076f"

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