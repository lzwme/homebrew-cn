cask "font-antic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanticAntic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Antic"
  homepage "https:fonts.google.comspecimenAntic"

  font "Antic-Regular.ttf"

  # No zap stanza required
end