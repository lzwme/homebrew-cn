cask "font-chocolate-classical-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchocolateclassicalsansChocolateClassicalSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chocolate Classical Sans"
  homepage "https:fonts.google.comspecimenChocolate+Classical+Sans"

  font "ChocolateClassicalSans-Regular.ttf"

  # No zap stanza required
end