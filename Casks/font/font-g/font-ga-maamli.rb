cask "font-ga-maamli" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgamaamliGaMaamli-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ga Maamli"
  homepage "https:fonts.google.comspecimenGa+Maamli"

  font "GaMaamli-Regular.ttf"

  # No zap stanza required
end