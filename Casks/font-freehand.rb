cask "font-freehand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfreehandFreehand-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Freehand"
  homepage "https:fonts.google.comspecimenFreehand"

  font "Freehand-Regular.ttf"

  # No zap stanza required
end