cask "font-noto-serif" do
  version "2.015"
  sha256 "0e9a43c8a4b94ac76f55069ed1d7385bbcaf6b99527a94deb5619e032b7e76c1"

  url "https:github.comnotofontslatin-greek-cyrillicreleasesdownloadNotoSerif-v#{version}NotoSerif-v#{version}.zip",
      verified: "github.comnotofonts"
  name "Noto Serif"
  homepage "https:notofonts.github.io"

  no_autobump! because: :requires_manual_review

  livecheck do
    url :url
    regex(^NotoSerif-v?(\d+(?:\.\d+)+)$i)
  end

  font "NotoSerifunhintedvariable-ttfNotoSerif-Italic[wdth,wght].ttf"
  font "NotoSerifunhintedvariable-ttfNotoSerif[wdth,wght].ttf"

  # No zap stanza required
end