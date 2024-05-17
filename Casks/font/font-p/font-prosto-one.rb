cask "font-prosto-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprostooneProstoOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Prosto One"
  homepage "https:fonts.google.comspecimenProsto+One"

  font "ProstoOne-Regular.ttf"

  # No zap stanza required
end