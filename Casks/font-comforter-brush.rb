cask "font-comforter-brush" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcomforterbrushComforterBrush-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Comforter Brush"
  desc "Brushy companion of comforter, a bouncy, upright brush style script"
  homepage "https:fonts.google.comspecimenComforter+Brush"

  font "ComforterBrush-Regular.ttf"

  # No zap stanza required
end