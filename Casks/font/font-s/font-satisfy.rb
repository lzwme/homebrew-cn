cask "font-satisfy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachesatisfySatisfy-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Satisfy"
  homepage "https:fonts.google.comspecimenSatisfy"

  font "Satisfy-Regular.ttf"

  # No zap stanza required
end