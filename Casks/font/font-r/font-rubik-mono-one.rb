cask "font-rubik-mono-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikmonooneRubikMonoOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Mono One"
  homepage "https:fonts.google.comspecimenRubik+Mono+One"

  font "RubikMonoOne-Regular.ttf"

  # No zap stanza required
end