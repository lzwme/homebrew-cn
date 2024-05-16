cask "font-fenix" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfenixFenix-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fenix"
  homepage "https:fonts.google.comspecimenFenix"

  font "Fenix-Regular.ttf"

  # No zap stanza required
end