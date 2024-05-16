cask "font-lemon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllemonLemon-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lemon"
  homepage "https:fonts.google.comspecimenLemon"

  font "Lemon-Regular.ttf"

  # No zap stanza required
end