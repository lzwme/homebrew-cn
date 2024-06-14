cask "font-protest-guerrilla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprotestguerrillaProtestGuerrilla-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Protest Guerrilla"
  homepage "https:fonts.google.comspecimenProtest+Guerrilla"

  font "ProtestGuerrilla-Regular.ttf"

  # No zap stanza required
end