cask "font-metrophobic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmetrophobicMetrophobic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Metrophobic"
  homepage "https:fonts.google.comspecimenMetrophobic"

  font "Metrophobic-Regular.ttf"

  # No zap stanza required
end