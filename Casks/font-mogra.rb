cask "font-mogra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmograMogra-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mogra"
  homepage "https:fonts.google.comspecimenMogra"

  font "Mogra-Regular.ttf"

  # No zap stanza required
end