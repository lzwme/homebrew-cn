cask "font-imbue" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflimbueImbue%5Bopsz%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Imbue"
  desc "Variable condensed Didone font"
  homepage "https:fonts.google.comspecimenImbue"

  font "Imbue[opsz,wght].ttf"

  # No zap stanza required
end