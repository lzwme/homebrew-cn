cask "font-sorts-mill-goudy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsortsmillgoudy"
  name "Sorts Mill Goudy"
  homepage "https:fonts.google.comspecimenSorts+Mill+Goudy"

  font "SortsMillGoudy-Italic.ttf"
  font "SortsMillGoudy-Regular.ttf"

  # No zap stanza required
end