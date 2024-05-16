cask "font-arizonia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarizoniaArizonia-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Arizonia"
  homepage "https:fonts.google.comspecimenArizonia"

  font "Arizonia-Regular.ttf"

  # No zap stanza required
end