cask "font-marcellus" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarcellusMarcellus-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Marcellus"
  homepage "https:fonts.google.comspecimenMarcellus"

  font "Marcellus-Regular.ttf"

  # No zap stanza required
end