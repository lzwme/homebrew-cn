cask "font-kablammo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkablammoKablammo%5BMORF%5D.ttf",
      verified: "github.comgooglefonts"
  name "Kablammo"
  homepage "https:fonts.google.comspecimenKablammo"

  font "Kablammo[MORF].ttf"

  # No zap stanza required
end