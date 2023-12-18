cask "font-khand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkhand"
  name "Khand"
  homepage "https:fonts.google.comspecimenKhand"

  font "Khand-Bold.ttf"
  font "Khand-Light.ttf"
  font "Khand-Medium.ttf"
  font "Khand-Regular.ttf"
  font "Khand-SemiBold.ttf"

  # No zap stanza required
end