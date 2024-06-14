cask "font-nerko-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnerkooneNerkoOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nerko One"
  homepage "https:fonts.google.comspecimenNerko+One"

  font "NerkoOne-Regular.ttf"

  # No zap stanza required
end