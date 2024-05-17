cask "font-mea-culpa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmeaculpaMeaCulpa-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mea Culpa"
  desc "Beautiful formal script with flourished capitals"
  homepage "https:fonts.google.comspecimenMea+Culpa"

  font "MeaCulpa-Regular.ttf"

  # No zap stanza required
end