cask "font-arbutus" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarbutusArbutus-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Arbutus"
  homepage "https:fonts.google.comspecimenArbutus"

  font "Arbutus-Regular.ttf"

  # No zap stanza required
end