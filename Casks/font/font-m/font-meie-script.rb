cask "font-meie-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmeiescriptMeieScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Meie Script"
  homepage "https:fonts.google.comspecimenMeie+Script"

  font "MeieScript-Regular.ttf"

  # No zap stanza required
end