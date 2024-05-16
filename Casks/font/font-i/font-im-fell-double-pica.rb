cask "font-im-fell-double-pica" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflimfelldoublepica"
  name "IM Fell Double Pica"
  homepage "https:fonts.google.comspecimenIM+Fell+Double+Pica"

  font "IMFELLDoublePica-Italic.ttf"
  font "IMFELLDoublePica-Regular.ttf"

  # No zap stanza required
end