cask "font-oxanium" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloxaniumOxanium%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Oxanium"
  homepage "https:fonts.google.comspecimenOxanium"

  font "Oxanium[wght].ttf"

  # No zap stanza required
end