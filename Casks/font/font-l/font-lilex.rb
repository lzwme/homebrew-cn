cask "font-lilex" do
  version "2.520"
  sha256 "c19cac5d41d763f6edd92fed1799e2522ee994452ab6ce979bbcedcef187c46d"

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