cask "font-jaro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljaroJaro%5Bopsz%5D.ttf",
      verified: "github.comgooglefonts"
  name "Jaro"
  desc "Global display typeface inspired by the work of jaroslav benda"
  homepage "https:fonts.google.comspecimenJaro"

  font "Jaro[opsz].ttf"

  # No zap stanza required
end