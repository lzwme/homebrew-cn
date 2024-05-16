cask "font-adamina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofladaminaAdamina-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Adamina"
  homepage "https:fonts.google.comspecimenAdamina"

  font "Adamina-Regular.ttf"

  # No zap stanza required
end