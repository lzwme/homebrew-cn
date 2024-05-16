cask "font-ballet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflballetBallet%5Bopsz%5D.ttf",
      verified: "github.comgooglefonts"
  name "Ballet"
  desc "Designed by maximiliano sproviero and developed by eduardo tunni"
  homepage "https:fonts.google.comspecimenBallet"

  font "Ballet[opsz].ttf"

  # No zap stanza required
end