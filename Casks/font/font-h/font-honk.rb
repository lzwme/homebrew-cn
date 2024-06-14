cask "font-honk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhonkHonk%5BMORF%2CSHLN%5D.ttf",
      verified: "github.comgooglefonts"
  name "Honk"
  homepage "https:fonts.google.comspecimenHonk"

  font "Honk[MORF,SHLN].ttf"

  # No zap stanza required
end