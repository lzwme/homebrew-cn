cask "font-neucha" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflneuchaNeucha.ttf",
      verified: "github.comgooglefonts"
  name "Neucha"
  homepage "https:fonts.google.comspecimenNeucha"

  font "Neucha.ttf"

  # No zap stanza required
end