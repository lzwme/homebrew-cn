cask "font-huninn" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhuninnHuninn-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Huninn"
  homepage "https:fonts.google.comspecimenHuninn"

  font "Huninn-Regular.ttf"

  # No zap stanza required
end