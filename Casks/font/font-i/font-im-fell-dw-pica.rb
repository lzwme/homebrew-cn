cask "font-im-fell-dw-pica" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflimfelldwpica"
  name "IM Fell DW Pica"
  homepage "https:fonts.google.comspecimenIM+Fell+DW+Pica"

  font "IMFePIit28P.ttf"
  font "IMFePIrm28P.ttf"

  # No zap stanza required
end