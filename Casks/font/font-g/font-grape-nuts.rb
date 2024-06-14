cask "font-grape-nuts" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgrapenutsGrapeNuts-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Grape Nuts"
  homepage "https:fonts.google.comspecimenGrape+Nuts"

  font "GrapeNuts-Regular.ttf"

  # No zap stanza required
end