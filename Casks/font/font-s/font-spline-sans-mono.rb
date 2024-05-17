cask "font-spline-sans-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsplinesansmono"
  name "Spline Sans Mono"
  desc "Original typeface initiated by the spline team"
  homepage "https:fonts.google.comspecimenSpline+Sans+Mono"

  font "SplineSansMono-Italic[wght].ttf"
  font "SplineSansMono[wght].ttf"

  # No zap stanza required
end