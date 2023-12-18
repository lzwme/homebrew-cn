cask "font-noto-traditional-nushu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnototraditionalnushuNotoTraditionalNushu%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Traditional Nushu"
  homepage "https:fonts.google.comspecimenNoto+Traditional+Nushu"

  font "NotoTraditionalNushu[wght].ttf"

  # No zap stanza required
end