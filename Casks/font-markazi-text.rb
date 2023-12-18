cask "font-markazi-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarkazitextvfbetaMarkaziText-VF.ttf",
      verified: "github.comgooglefonts"
  name "Markazi Text"
  desc "Contemporary and highly readable typeface"
  homepage "https:fonts.google.comspecimenMarkazi+Text"

  font "MarkaziText-VF.ttf"

  # No zap stanza required
end