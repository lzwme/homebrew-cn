cask "font-triodion" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltriodionTriodion-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Triodion"
  homepage "https:fonts.google.comspecimenTriodion"

  font "Triodion-Regular.ttf"

  # No zap stanza required
end