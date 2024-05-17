cask "font-parisienne" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflparisienneParisienne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Parisienne"
  homepage "https:fonts.google.comspecimenParisienne"

  font "Parisienne-Regular.ttf"

  # No zap stanza required
end