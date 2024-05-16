cask "font-joti-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljotioneJotiOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Joti One"
  homepage "https:fonts.google.comspecimenJoti+One"

  font "JotiOne-Regular.ttf"

  # No zap stanza required
end