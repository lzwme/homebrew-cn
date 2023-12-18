cask "font-miss-fajardose" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmissfajardoseMissFajardose-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Miss Fajardose"
  homepage "https:fonts.google.comspecimenMiss+Fajardose"

  font "MissFajardose-Regular.ttf"

  # No zap stanza required
end