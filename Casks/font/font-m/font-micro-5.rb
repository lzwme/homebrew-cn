cask "font-micro-5" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmicro5Micro5-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Micro 5"
  homepage "https:fonts.google.comspecimenMicro+5"

  font "Micro5-Regular.ttf"

  # No zap stanza required
end