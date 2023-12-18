cask "font-cinzel-decorative" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcinzeldecorative"
  name "Cinzel Decorative"
  homepage "https:fonts.google.comspecimenCinzel+Decorative"

  font "CinzelDecorative-Black.ttf"
  font "CinzelDecorative-Bold.ttf"
  font "CinzelDecorative-Regular.ttf"

  # No zap stanza required
end