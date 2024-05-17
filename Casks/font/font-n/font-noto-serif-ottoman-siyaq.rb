cask "font-noto-serif-ottoman-siyaq" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifottomansiyaqNotoSerifOttomanSiyaq-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Ottoman Siyaq"
  desc "Modulated (“serif”) design for the arabic form of the siyaq numeral system"
  homepage "https:fonts.google.comspecimenNoto+Serif+Ottoman+Siyaq"

  font "NotoSerifOttomanSiyaq-Regular.ttf"

  # No zap stanza required
end