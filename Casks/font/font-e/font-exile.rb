cask "font-exile" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflexileExile-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Exile"
  homepage "https:fonts.google.comspecimenExile"

  font "Exile-Regular.ttf"

  # No zap stanza required
end