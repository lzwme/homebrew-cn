cask "font-lilex" do
  version "2.400"
  sha256 "6e50639476221f8d11c859d4e8d36d164c236e049f6625414d4cf82b02f1f10f"

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