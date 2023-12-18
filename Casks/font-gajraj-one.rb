cask "font-gajraj-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgajrajoneGajrajOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gajraj One"
  homepage "https:fonts.google.comspecimenGajraj+One"

  font "GajrajOne-Regular.ttf"

  # No zap stanza required
end