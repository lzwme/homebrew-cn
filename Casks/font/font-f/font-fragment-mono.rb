cask "font-fragment-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfragmentmono"
  name "Fragment Mono"
  homepage "https:fonts.google.comspecimenFragment+Mono"

  font "FragmentMono-Italic.ttf"
  font "FragmentMono-Regular.ttf"

  # No zap stanza required
end