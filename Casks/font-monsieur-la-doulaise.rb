cask "font-monsieur-la-doulaise" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmonsieurladoulaiseMonsieurLaDoulaise-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Monsieur La Doulaise"
  homepage "https:fonts.google.comspecimenMonsieur+La+Doulaise"

  font "MonsieurLaDoulaise-Regular.ttf"

  # No zap stanza required
end