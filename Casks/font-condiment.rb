cask "font-condiment" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcondimentCondiment-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Condiment"
  homepage "https:fonts.google.comspecimenCondiment"

  font "Condiment-Regular.ttf"

  # No zap stanza required
end