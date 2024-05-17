cask "font-micro-5" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmicro5Micro5-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Micro 5"
  desc "Teeny-tiny typeface that can fit anywhere on your project"
  homepage "https:fonts.google.comspecimenMicro+5"

  font "Micro5-Regular.ttf"

  # No zap stanza required
end