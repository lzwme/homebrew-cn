cask "font-vampiro-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvampirooneVampiroOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Vampiro One"
  homepage "https:fonts.google.comspecimenVampiro+One"

  font "VampiroOne-Regular.ttf"

  # No zap stanza required
end