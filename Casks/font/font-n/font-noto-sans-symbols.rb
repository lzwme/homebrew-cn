cask "font-noto-sans-symbols" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssymbolsNotoSansSymbols%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Symbols"
  homepage "https:fonts.google.comspecimenNoto+Sans+Symbols"

  font "NotoSansSymbols[wght].ttf"

  # No zap stanza required
end