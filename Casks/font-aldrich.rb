cask "font-aldrich" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaldrichAldrich-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Aldrich"
  homepage "https:fonts.google.comspecimenAldrich"

  font "Aldrich-Regular.ttf"

  # No zap stanza required
end