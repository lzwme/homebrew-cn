cask "font-onest" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflonestOnest%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Onest"
  homepage "https:fonts.google.comspecimenOnest"

  font "Onest[wght].ttf"

  # No zap stanza required
end