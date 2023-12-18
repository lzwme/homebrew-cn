cask "font-butcherman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbutchermanButcherman-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Butcherman"
  homepage "https:fonts.google.comspecimenButcherman"

  font "Butcherman-Regular.ttf"

  # No zap stanza required
end