cask "font-ubuntu-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainuflubuntucondensedUbuntuCondensed-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ubuntu Condensed"
  homepage "https:fonts.google.comspecimenUbuntu+Condensed"

  font "UbuntuCondensed-Regular.ttf"

  # No zap stanza required
end