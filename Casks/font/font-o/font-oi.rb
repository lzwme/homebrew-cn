cask "font-oi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloiOi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Oi"
  homepage "https:fonts.google.comspecimenOi"

  font "Oi-Regular.ttf"

  # No zap stanza required
end