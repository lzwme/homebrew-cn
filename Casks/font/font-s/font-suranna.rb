cask "font-suranna" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsurannaSuranna-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Suranna"
  homepage "https:fonts.google.comspecimenSuranna"

  font "Suranna-Regular.ttf"

  # No zap stanza required
end