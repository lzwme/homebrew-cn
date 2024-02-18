cask "font-noto-sans" do
  version "2.013"
  sha256 "9fd595dd701d7ea103a9ba8a9cfdcf0c35c5574ef754fecabe718eadad8bccde"

  url "https:github.comnotofontslatin-greek-cyrillicreleasesdownloadNotoSans-v#{version}NotoSans-v#{version}.zip",
      verified: "github.comnotofonts"
  name "Noto Sans"
  desc "Sans-serif variable font"
  homepage "https:notofonts.github.io"

  livecheck do
    url :url
    regex(^NotoSans-v?(\d+(?:\.\d+)+)$i)
  end

  font "NotoSansunhintedvariableNotoSans-Italic[wdth,wght].ttf"
  font "NotoSansunhintedvariableNotoSans[wdth,wght].ttf"
end