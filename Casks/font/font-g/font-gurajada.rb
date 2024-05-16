cask "font-gurajada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgurajadaGurajada-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gurajada"
  homepage "https:fonts.google.comspecimenGurajada"

  font "Gurajada-Regular.ttf"

  # No zap stanza required
end