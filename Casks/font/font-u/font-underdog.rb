cask "font-underdog" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflunderdogUnderdog-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Underdog"
  homepage "https:fonts.google.comspecimenUnderdog"

  font "Underdog-Regular.ttf"

  # No zap stanza required
end