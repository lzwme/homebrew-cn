cask "font-alexandria" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalexandriaAlexandria%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Alexandria"
  desc "9 weights font family made in matching to the latin type Montserrat"
  homepage "https:fonts.google.comspecimenAlexandria"

  font "Alexandria[wght].ttf"

  # No zap stanza required
end