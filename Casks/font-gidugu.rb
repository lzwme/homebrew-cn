cask "font-gidugu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgiduguGidugu-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gidugu"
  homepage "https:fonts.google.comspecimenGidugu"

  font "Gidugu-Regular.ttf"

  # No zap stanza required
end