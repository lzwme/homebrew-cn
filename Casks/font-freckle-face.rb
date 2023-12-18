cask "font-freckle-face" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfrecklefaceFreckleFace-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Freckle Face"
  homepage "https:fonts.google.comspecimenFreckle+Face"

  font "FreckleFace-Regular.ttf"

  # No zap stanza required
end