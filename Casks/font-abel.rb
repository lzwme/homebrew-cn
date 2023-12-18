cask "font-abel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflabelAbel-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Abel"
  homepage "https:fonts.google.comspecimenAbel"

  font "Abel-Regular.ttf"

  # No zap stanza required
end