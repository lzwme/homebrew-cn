cask "font-ysabeau-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflysabeauscYsabeauSC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Ysabeau SC"
  desc "Exercise in restraint"
  homepage "https:fonts.google.comspecimenYsabeau+SC"

  font "YsabeauSC[wght].ttf"

  # No zap stanza required
end