cask "font-ponomar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflponomarPonomar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ponomar"
  homepage "https:fonts.google.comspecimenPonomar"

  font "Ponomar-Regular.ttf"

  # No zap stanza required
end