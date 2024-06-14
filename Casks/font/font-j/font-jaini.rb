cask "font-jaini" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljainiJaini-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jaini"
  homepage "https:fonts.google.comspecimenJaini"

  font "Jaini-Regular.ttf"

  # No zap stanza required
end