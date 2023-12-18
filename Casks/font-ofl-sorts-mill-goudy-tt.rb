cask "font-ofl-sorts-mill-goudy-tt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloflsortsmillgoudytt"
  name "OFL Sorts Mill Goudy TT"
  homepage "https:fonts.google.comspecimenSorts+Mill+Goudy"

  font "OFLGoudyStMTT-Italic.ttf"
  font "OFLGoudyStMTT.ttf"

  # No zap stanza required
end