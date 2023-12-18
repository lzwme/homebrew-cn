cask "font-contrail-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcontrailoneContrailOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Contrail One"
  homepage "https:fonts.google.comspecimenContrail+One"

  font "ContrailOne-Regular.ttf"

  # No zap stanza required
end