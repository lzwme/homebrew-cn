cask "font-combo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcomboCombo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Combo"
  homepage "https:fonts.google.comspecimenCombo"

  font "Combo-Regular.ttf"

  # No zap stanza required
end