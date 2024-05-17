cask "font-piedra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpiedraPiedra-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Piedra"
  homepage "https:fonts.google.comspecimenPiedra"

  font "Piedra-Regular.ttf"

  # No zap stanza required
end