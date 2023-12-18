cask "font-bakbak-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbakbakoneBakbakOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bakbak One"
  desc "Render anything from a warning to a mockery"
  homepage "https:fonts.google.comspecimenBakbak+One"

  font "BakbakOne-Regular.ttf"

  # No zap stanza required
end