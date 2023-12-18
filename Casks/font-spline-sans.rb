cask "font-spline-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsplinesansSplineSans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Spline Sans"
  desc "Original typeface initiated by the spline team"
  homepage "https:fonts.google.comspecimenSpline+Sans"

  font "SplineSans[wght].ttf"

  # No zap stanza required
end