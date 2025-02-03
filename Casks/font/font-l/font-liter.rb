cask "font-liter" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflliterLiter-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Liter"
  homepage "https:fonts.google.comspecimenLiter"

  font "Liter-Regular.ttf"

  # No zap stanza required
end