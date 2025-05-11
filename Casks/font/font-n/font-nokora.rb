cask "font-nokora" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnokoraNokora%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Nokora"
  homepage "https:fonts.google.comspecimenNokora"

  font "Nokora[wght].ttf"

  # No zap stanza required
end