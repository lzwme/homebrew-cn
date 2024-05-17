cask "font-orbitron" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflorbitronOrbitron%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Orbitron"
  homepage "https:fonts.google.comspecimenOrbitron"

  font "Orbitron[wght].ttf"

  # No zap stanza required
end