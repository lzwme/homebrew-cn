cask "font-pragati-narrow" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpragatinarrow"
  name "Pragati Narrow"
  homepage "https:fonts.google.comspecimenPragati+Narrow"

  font "PragatiNarrow-Bold.ttf"
  font "PragatiNarrow-Regular.ttf"

  # No zap stanza required
end