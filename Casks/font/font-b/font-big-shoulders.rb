cask "font-big-shoulders" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersBigShoulders%5Bopsz%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders"
  homepage "https:fonts.google.comspecimenBig+Shoulders"

  font "BigShoulders[opsz,wght].ttf"

  # No zap stanza required
end