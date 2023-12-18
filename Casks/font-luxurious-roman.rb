cask "font-luxurious-roman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflluxuriousromanLuxuriousRoman-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Luxurious Roman"
  desc "Semi-hand lettered font with inconsistent serifs"
  homepage "https:fonts.google.comspecimenLuxurious+Roman"

  font "LuxuriousRoman-Regular.ttf"

  # No zap stanza required
end