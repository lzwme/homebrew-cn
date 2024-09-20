cask "font-noto-serif" do
  version "2.014"
  sha256 "6abce0a80df4ef6d5a944d60c81099364481d6a7015b0721d87bc4c16acc1fd3"

  url "https:github.comnotofontslatin-greek-cyrillicreleasesdownloadNotoSerif-v#{version}NotoSerif-v#{version}.zip",
      verified: "github.comnotofonts"
  name "Noto Sans"
  homepage "https:notofonts.github.io"

  livecheck do
    url :url
    regex(^NotoSerif-v?(\d+(?:\.\d+)+)$i)
  end

  font "NotoSerifunhintedvariable-ttfNotoSerif-Italic[wdth,wght].ttf"
  font "NotoSerifunhintedvariable-ttfNotoSerif[wdth,wght].ttf"

  # No zap stanza required
end