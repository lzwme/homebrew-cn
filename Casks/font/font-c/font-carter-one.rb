cask "font-carter-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcarteroneCarterOne.ttf",
      verified: "github.comgooglefonts"
  name "Carter One"
  homepage "https:fonts.google.comspecimenCarter+One"

  font "CarterOne.ttf"

  # No zap stanza required
end