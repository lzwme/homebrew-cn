cask "font-damion" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldamionDamion-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Damion"
  homepage "https:fonts.google.comspecimenDamion"

  font "Damion-Regular.ttf"

  # No zap stanza required
end