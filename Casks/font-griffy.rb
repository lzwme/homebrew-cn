cask "font-griffy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgriffyGriffy-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Griffy"
  homepage "https:fonts.google.comspecimenGriffy"

  font "Griffy-Regular.ttf"

  # No zap stanza required
end