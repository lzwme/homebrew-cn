cask "font-spinnaker" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflspinnakerSpinnaker-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Spinnaker"
  homepage "https:fonts.google.comspecimenSpinnaker"

  font "Spinnaker-Regular.ttf"

  # No zap stanza required
end