cask "font-prata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprataPrata-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Prata"
  homepage "https:fonts.google.comspecimenPrata"

  font "Prata-Regular.ttf"

  # No zap stanza required
end