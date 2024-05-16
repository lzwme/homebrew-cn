cask "font-barrio" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbarrioBarrio-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Barrio"
  homepage "https:fonts.google.comspecimenBarrio"

  font "Barrio-Regular.ttf"

  # No zap stanza required
end