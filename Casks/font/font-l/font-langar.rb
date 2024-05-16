cask "font-langar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllangarLangar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Langar"
  desc "One-weight latingurmukhi display font based on informal, playful letterforms"
  homepage "https:fonts.google.comspecimenLangar"

  font "Langar-Regular.ttf"

  # No zap stanza required
end