cask "font-metamorphous" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmetamorphousMetamorphous-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Metamorphous"
  homepage "https:fonts.google.comspecimenMetamorphous"

  font "Metamorphous-Regular.ttf"

  # No zap stanza required
end