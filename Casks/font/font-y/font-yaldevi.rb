cask "font-yaldevi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyaldeviYaldevi%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Yaldevi"
  homepage "https:fonts.google.comspecimenYaldevi"

  font "Yaldevi[wght].ttf"

  # No zap stanza required
end