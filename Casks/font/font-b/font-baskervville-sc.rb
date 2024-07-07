cask "font-baskervville-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbaskervvillescBaskervvilleSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Baskervville SC"
  homepage "https:fonts.google.comspecimenBaskervville+SC"

  font "BaskervvilleSC-Regular.ttf"

  # No zap stanza required
end