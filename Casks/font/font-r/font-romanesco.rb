cask "font-romanesco" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflromanescoRomanesco-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Romanesco"
  homepage "https:fonts.google.comspecimenRomanesco"

  font "Romanesco-Regular.ttf"

  # No zap stanza required
end