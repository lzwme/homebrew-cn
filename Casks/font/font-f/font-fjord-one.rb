cask "font-fjord-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfjordoneFjordOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fjord One"
  homepage "https:fonts.google.comspecimenFjord+One"

  font "FjordOne-Regular.ttf"

  # No zap stanza required
end