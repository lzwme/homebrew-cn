cask "font-gruppo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgruppoGruppo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gruppo"
  homepage "https:fonts.google.comspecimenGruppo"

  font "Gruppo-Regular.ttf"

  # No zap stanza required
end