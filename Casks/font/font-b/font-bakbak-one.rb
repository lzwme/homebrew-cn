cask "font-bakbak-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbakbakoneBakbakOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bakbak One"
  homepage "https:fonts.google.comspecimenBakbak+One"

  font "BakbakOne-Regular.ttf"

  # No zap stanza required
end