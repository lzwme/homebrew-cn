cask "font-mandali" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmandaliMandali-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mandali"
  homepage "https:fonts.google.comspecimenMandali"

  font "Mandali-Regular.ttf"

  # No zap stanza required
end