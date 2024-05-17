cask "font-sevillana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsevillanaSevillana-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sevillana"
  homepage "https:fonts.google.comspecimenSevillana"

  font "Sevillana-Regular.ttf"

  # No zap stanza required
end