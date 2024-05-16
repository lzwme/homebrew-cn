cask "font-frijole" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfrijoleFrijole-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Frijole"
  homepage "https:fonts.google.comspecimenFrijole"

  font "Frijole-Regular.ttf"

  # No zap stanza required
end