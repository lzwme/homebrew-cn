cask "font-hina-mincho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhinaminchoHinaMincho-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hina Mincho"
  homepage "https:fonts.google.comspecimenHina+Mincho"

  font "HinaMincho-Regular.ttf"

  # No zap stanza required
end