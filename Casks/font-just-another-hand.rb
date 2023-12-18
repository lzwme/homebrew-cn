cask "font-just-another-hand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachejustanotherhandJustAnotherHand-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Just Another Hand"
  homepage "https:fonts.google.comspecimenJust+Another+Hand"

  font "JustAnotherHand-Regular.ttf"

  # No zap stanza required
end