cask "font-anek-gurmukhi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekgurmukhiAnekGurmukhi%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Gurmukhi"
  homepage "https:fonts.google.comspecimenAnek+Gurmukhi"

  font "AnekGurmukhi[wdth,wght].ttf"

  # No zap stanza required
end