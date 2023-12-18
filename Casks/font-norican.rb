cask "font-norican" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnoricanNorican-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Norican"
  homepage "https:fonts.google.comspecimenNorican"

  font "Norican-Regular.ttf"

  # No zap stanza required
end