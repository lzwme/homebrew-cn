cask "font-noto-serif-old-uyghur" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifolduyghurNotoSerifOldUyghur-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Old Uyghur"
  homepage "https:fonts.google.comspecimenNoto+Serif+Old+Uyghur"

  font "NotoSerifOldUyghur-Regular.ttf"

  # No zap stanza required
end