cask "font-caprasimo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcaprasimoCaprasimo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Caprasimo"
  desc "Based on fraunces"
  homepage "https:fonts.google.comspecimenCaprasimo"

  font "Caprasimo-Regular.ttf"

  # No zap stanza required
end