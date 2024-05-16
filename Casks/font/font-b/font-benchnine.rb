cask "font-benchnine" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbenchnine"
  name "BenchNine"
  homepage "https:fonts.google.comspecimenBenchNine"

  font "BenchNine-Bold.ttf"
  font "BenchNine-Light.ttf"
  font "BenchNine-Regular.ttf"

  # No zap stanza required
end