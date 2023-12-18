cask "font-im-fell-french-canon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflimfellfrenchcanon"
  name "IM Fell French Canon"
  homepage "https:fonts.google.comspecimenIM+Fell+French+Canon"

  font "IMFeFCit28P.ttf"
  font "IMFeFCrm28P.ttf"

  # No zap stanza required
end