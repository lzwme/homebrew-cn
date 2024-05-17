cask "font-tektur" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltekturTektur%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Tektur"
  desc "Set high allowing for compact typesetting"
  homepage "https:fonts.google.comspecimenTektur"

  font "Tektur[wdth,wght].ttf"

  # No zap stanza required
end