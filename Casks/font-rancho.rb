cask "font-rancho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheranchoRancho-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rancho"
  homepage "https:fonts.google.comspecimenRancho"

  font "Rancho-Regular.ttf"

  # No zap stanza required
end