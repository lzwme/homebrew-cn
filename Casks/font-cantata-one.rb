cask "font-cantata-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcantataoneCantataOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cantata One"
  homepage "https:fonts.google.comspecimenCantata+One"

  font "CantataOne-Regular.ttf"

  # No zap stanza required
end