cask "font-42dot-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofl42dotsans42dotSans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "42dot Sans"
  homepage "https:fonts.google.comspecimen42dot+Sans"

  font "42dotSans[wght].ttf"

  # No zap stanza required
end