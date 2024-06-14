cask "font-kolker-brush" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkolkerbrushKolkerBrush-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kolker Brush"
  homepage "https:fonts.google.comspecimenKolker+Brush"

  font "KolkerBrush-Regular.ttf"

  # No zap stanza required
end