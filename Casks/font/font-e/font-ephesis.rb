cask "font-ephesis" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflephesisEphesis-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ephesis"
  homepage "https:fonts.google.comspecimenEphesis"

  font "Ephesis-Regular.ttf"

  # No zap stanza required
end