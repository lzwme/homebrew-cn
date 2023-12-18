cask "font-yantramanav" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflyantramanav"
  name "Yantramanav"
  homepage "https:fonts.google.comspecimenYantramanav"

  font "Yantramanav-Black.ttf"
  font "Yantramanav-Bold.ttf"
  font "Yantramanav-Light.ttf"
  font "Yantramanav-Medium.ttf"
  font "Yantramanav-Regular.ttf"
  font "Yantramanav-Thin.ttf"

  # No zap stanza required
end