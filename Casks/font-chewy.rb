cask "font-chewy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachechewyChewy-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chewy"
  homepage "https:fonts.google.comspecimenChewy"

  font "Chewy-Regular.ttf"

  # No zap stanza required
end