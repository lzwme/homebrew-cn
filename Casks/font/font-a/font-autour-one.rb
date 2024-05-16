cask "font-autour-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflautouroneAutourOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Autour One"
  homepage "https:fonts.google.comspecimenAutour+One"

  font "AutourOne-Regular.ttf"

  # No zap stanza required
end