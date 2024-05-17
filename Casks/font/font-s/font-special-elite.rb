cask "font-special-elite" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachespecialeliteSpecialElite-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Special Elite"
  homepage "https:fonts.google.comspecimenSpecial+Elite"

  font "SpecialElite-Regular.ttf"

  # No zap stanza required
end