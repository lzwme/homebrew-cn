cask "font-hermeneus-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhermeneusoneHermeneusOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hermeneus One"
  homepage "https:fonts.google.comspecimenHermeneus+One"

  font "HermeneusOne-Regular.ttf"

  # No zap stanza required
end