cask "font-germania-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgermaniaoneGermaniaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Germania One"
  homepage "https:fonts.google.comspecimenGermania+One"

  font "GermaniaOne-Regular.ttf"

  # No zap stanza required
end