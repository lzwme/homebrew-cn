cask "font-david-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldavidlibre"
  name "David Libre"
  desc "Led by meir sadan, a type designer based in tel aviv, israel"
  homepage "https:fonts.google.comspecimenDavid+Libre"

  font "DavidLibre-Bold.ttf"
  font "DavidLibre-Medium.ttf"
  font "DavidLibre-Regular.ttf"

  # No zap stanza required
end