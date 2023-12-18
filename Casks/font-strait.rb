cask "font-strait" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstraitStrait-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Strait"
  homepage "https:fonts.google.comspecimenStrait"

  font "Strait-Regular.ttf"

  # No zap stanza required
end