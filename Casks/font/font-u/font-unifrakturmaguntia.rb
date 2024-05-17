cask "font-unifrakturmaguntia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflunifrakturmaguntiaUnifrakturMaguntia-Book.ttf",
      verified: "github.comgooglefonts"
  name "UnifrakturMaguntia"
  homepage "https:fonts.google.comspecimenUnifrakturMaguntia"

  font "UnifrakturMaguntia-Book.ttf"

  # No zap stanza required
end