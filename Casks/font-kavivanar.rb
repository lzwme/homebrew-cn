cask "font-kavivanar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkavivanarKavivanar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kavivanar"
  homepage "https:fonts.google.comspecimenKavivanar"

  font "Kavivanar-Regular.ttf"

  # No zap stanza required
end