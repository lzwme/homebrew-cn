cask "font-nanum-brush-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnanumbrushscriptNanumBrushScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nanum Brush Script"
  homepage "https:fonts.google.comspecimenNanum+Brush+Script"

  font "NanumBrushScript-Regular.ttf"

  # No zap stanza required
end