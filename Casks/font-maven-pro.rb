cask "font-maven-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmavenproMavenPro%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Maven Pro"
  homepage "https:fonts.google.comspecimenMaven+Pro"

  font "MavenPro[wght].ttf"

  # No zap stanza required
end