cask "font-yellowtail" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheyellowtailYellowtail-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yellowtail"
  homepage "https:fonts.google.comspecimenYellowtail"

  font "Yellowtail-Regular.ttf"

  # No zap stanza required
end