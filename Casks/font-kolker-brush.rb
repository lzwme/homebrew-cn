cask "font-kolker-brush" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkolkerbrushKolkerBrush-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kolker Brush"
  desc "Never recommended to use all caps when editing copy"
  homepage "https:fonts.google.comspecimenKolker+Brush"

  font "KolkerBrush-Regular.ttf"

  # No zap stanza required
end