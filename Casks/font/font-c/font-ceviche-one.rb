cask "font-ceviche-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcevicheoneCevicheOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ceviche One"
  homepage "https:fonts.google.comspecimenCeviche+One"

  font "CevicheOne-Regular.ttf"

  # No zap stanza required
end