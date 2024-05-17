cask "font-marcellus-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarcellusscMarcellusSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Marcellus SC"
  homepage "https:fonts.google.comspecimenMarcellus+SC"

  font "MarcellusSC-Regular.ttf"

  # No zap stanza required
end