cask "font-mclaren" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmclarenMcLaren-Regular.ttf",
      verified: "github.comgooglefonts"
  name "McLaren"
  homepage "https:fonts.google.comspecimenMcLaren"

  font "McLaren-Regular.ttf"

  # No zap stanza required
end