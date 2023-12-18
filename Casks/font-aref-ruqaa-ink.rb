cask "font-aref-ruqaa-ink" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarefruqaaink"
  name "Aref Ruqaa Ink"
  desc "Led by khaled hosny, a type designer based in cairo, egypt"
  homepage "https:fonts.google.comspecimenAref+Ruqaa+Ink"

  font "ArefRuqaaInk-Bold.ttf"
  font "ArefRuqaaInk-Regular.ttf"

  # No zap stanza required
end