cask "font-aref-ruqaa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarefruqaa"
  name "Aref Ruqaa"
  homepage "https:fonts.google.comspecimenAref+Ruqaa"

  font "ArefRuqaa-Bold.ttf"
  font "ArefRuqaa-Regular.ttf"

  # No zap stanza required
end