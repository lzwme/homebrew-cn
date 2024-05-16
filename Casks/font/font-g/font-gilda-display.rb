cask "font-gilda-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgildadisplayGildaDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gilda Display"
  homepage "https:fonts.google.comspecimenGilda+Display"

  font "GildaDisplay-Regular.ttf"

  # No zap stanza required
end