cask "font-anek-telugu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekteluguAnekTelugu%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Telugu"
  homepage "https:fonts.google.comspecimenAnek+Telugu"

  font "AnekTelugu[wdth,wght].ttf"

  # No zap stanza required
end