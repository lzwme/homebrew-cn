cask "font-grandiflora-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgrandifloraoneGrandifloraOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Grandiflora One"
  homepage "https:fonts.google.comspecimenGrandiflora+One"

  font "GrandifloraOne-Regular.ttf"

  # No zap stanza required
end