cask "font-rozha-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrozhaoneRozhaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rozha One"
  homepage "https:fonts.google.comspecimenRozha+One"

  font "RozhaOne-Regular.ttf"

  # No zap stanza required
end