cask "font-carme" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcarmeCarme-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Carme"
  homepage "https:fonts.google.comspecimenCarme"

  font "Carme-Regular.ttf"

  # No zap stanza required
end