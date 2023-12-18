cask "font-lilex" do
  version "2.300"
  sha256 "1e74df463a2a5e2ae75b45bed44941a3180933130f034d9c714a7b28d34f0daa"

  url "https:github.commishamyrtLilexreleasesdownload#{version}Lilex.zip"
  name "Lilex"
  desc "Programming font"
  homepage "https:github.commishamyrtLilex"

  font "ttfLilex-Bold.ttf"
  font "ttfLilex-ExtraLight.ttf"
  font "ttfLilex-ExtraThick.ttf"
  font "ttfLilex-Medium.ttf"
  font "ttfLilex-Regular.ttf"
  font "ttfLilex-Thin.ttf"
  font "variableLilex-VF.ttf"

  # No zap stanza required
end