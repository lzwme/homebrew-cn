cask "font-monofett" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmonofettMonofett-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Monofett"
  homepage "https:fonts.google.comspecimenMonofett"

  font "Monofett-Regular.ttf"

  # No zap stanza required
end