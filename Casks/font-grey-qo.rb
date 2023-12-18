cask "font-grey-qo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgreyqoGreyQo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Grey Qo"
  homepage "https:fonts.google.comspecimenGrey+Qo"

  font "GreyQo-Regular.ttf"

  # No zap stanza required
end