cask "font-rouge-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrougescriptRougeScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rouge Script"
  homepage "https:fonts.google.comspecimenRouge+Script"

  font "RougeScript-Regular.ttf"

  # No zap stanza required
end