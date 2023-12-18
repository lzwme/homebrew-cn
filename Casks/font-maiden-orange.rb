cask "font-maiden-orange" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachemaidenorangeMaidenOrange-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Maiden Orange"
  homepage "https:fonts.google.comspecimenMaiden+Orange"

  font "MaidenOrange-Regular.ttf"

  # No zap stanza required
end