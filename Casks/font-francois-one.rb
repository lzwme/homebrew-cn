cask "font-francois-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfrancoisoneFrancoisOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Francois One"
  homepage "https:fonts.google.comspecimenFrancois+One"

  font "FrancoisOne-Regular.ttf"

  # No zap stanza required
end