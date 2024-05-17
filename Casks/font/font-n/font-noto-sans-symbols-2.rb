cask "font-noto-sans-symbols-2" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssymbols2NotoSansSymbols2-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Symbols 2"
  homepage "https:fonts.google.comspecimenNoto+Sans+Symbols+2"

  font "NotoSansSymbols2-Regular.ttf"

  # No zap stanza required
end