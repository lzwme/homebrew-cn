cask "font-madimi-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmadimioneMadimiOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Madimi One"
  homepage "https:fonts.google.comspecimenMadimi+One"

  font "MadimiOne-Regular.ttf"

  # No zap stanza required
end