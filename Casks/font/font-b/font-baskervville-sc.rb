cask "font-baskervville-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbaskervvillescBaskervvilleSC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Baskervville SC"
  homepage "https:fonts.google.comspecimenBaskervville+SC"

  font "BaskervvilleSC[wght].ttf"

  # No zap stanza required
end