cask "font-jomolhari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljomolhariJomolhari-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jomolhari"
  homepage "https:fonts.google.comspecimenJomolhari"

  font "Jomolhari-Regular.ttf"

  # No zap stanza required
end