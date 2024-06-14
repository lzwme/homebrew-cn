cask "font-mooli" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmooliMooli-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mooli"
  homepage "https:fonts.google.comspecimenMooli"

  font "Mooli-Regular.ttf"

  # No zap stanza required
end