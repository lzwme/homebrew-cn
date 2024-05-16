cask "font-braah-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbraahoneBraahOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Braah One"
  desc "Bold and playful font"
  homepage "https:fonts.google.comspecimenBraah+One"

  font "BraahOne-Regular.ttf"

  # No zap stanza required
end