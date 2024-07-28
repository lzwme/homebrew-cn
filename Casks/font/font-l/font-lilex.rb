cask "font-lilex" do
  version "2.530"
  sha256 "b019fc0da5e3ece5c735aa040218d3b8c9945546d2d333598b587b1237a66c4a"

  url "https:github.commishamyrtLilexreleasesdownload#{version}Lilex.zip"
  name "Lilex"
  homepage "https:github.commishamyrtLilex"

  font "ttfLilex-Bold.ttf"
  font "ttfLilex-ExtraLight.ttf"
  font "ttfLilex-Medium.ttf"
  font "ttfLilex-Regular.ttf"
  font "ttfLilex-Thin.ttf"
  font "variableLilex[wght].ttf"

  # No zap stanza required
end