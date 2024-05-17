cask "font-pavanam" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpavanamPavanam-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pavanam"
  homepage "https:fonts.google.comspecimenPavanam"

  font "Pavanam-Regular.ttf"

  # No zap stanza required
end