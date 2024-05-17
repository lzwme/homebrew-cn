cask "font-ponnala" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflponnalaPonnala-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ponnala"
  homepage "https:fonts.google.comspecimenPonnala"

  font "Ponnala-Regular.ttf"

  # No zap stanza required
end