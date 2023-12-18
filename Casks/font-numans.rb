cask "font-numans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnumansNumans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Numans"
  homepage "https:fonts.google.comspecimenNumans"

  font "Numans-Regular.ttf"

  # No zap stanza required
end