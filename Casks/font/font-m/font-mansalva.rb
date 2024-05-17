cask "font-mansalva" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmansalvaMansalva-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mansalva"
  homepage "https:fonts.google.comspecimenMansalva"

  font "Mansalva-Regular.ttf"

  # No zap stanza required
end