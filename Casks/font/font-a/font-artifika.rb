cask "font-artifika" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflartifikaArtifika-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Artifika"
  homepage "https:fonts.google.comspecimenArtifika"

  font "Artifika-Regular.ttf"

  # No zap stanza required
end