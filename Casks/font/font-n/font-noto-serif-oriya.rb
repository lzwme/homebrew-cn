cask "font-noto-serif-oriya" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoseriforiyaNotoSerifOriya%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Oriya"
  desc "Modulated (“serif”) design for texts in the indic odia (oriya) script"
  homepage "https:fonts.google.comspecimenNoto+Serif+Oriya"

  font "NotoSerifOriya[wght].ttf"

  # No zap stanza required
end