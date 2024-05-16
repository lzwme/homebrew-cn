cask "font-gafata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgafataGafata-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gafata"
  homepage "https:fonts.google.comspecimenGafata"

  font "Gafata-Regular.ttf"

  # No zap stanza required
end