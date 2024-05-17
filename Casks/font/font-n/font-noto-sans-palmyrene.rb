cask "font-noto-sans-palmyrene" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanspalmyreneNotoSansPalmyrene-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Palmyrene"
  homepage "https:fonts.google.comspecimenNoto+Sans+Palmyrene"

  font "NotoSansPalmyrene-Regular.ttf"

  # No zap stanza required
end