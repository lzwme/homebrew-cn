cask "font-sulphur-point" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsulphurpoint"
  name "Sulphur Point"
  homepage "https:fonts.google.comspecimenSulphur+Point"

  font "SulphurPoint-Bold.ttf"
  font "SulphurPoint-Light.ttf"
  font "SulphurPoint-Regular.ttf"

  # No zap stanza required
end