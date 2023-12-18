cask "font-gluten" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflglutenGluten%5Bslnt%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Gluten"
  desc "Filling, we'll put it that way"
  homepage "https:fonts.google.comspecimenGluten"

  font "Gluten[slnt,wght].ttf"

  # No zap stanza required
end