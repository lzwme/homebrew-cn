cask "font-zilla-slab-highlight" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflzillaslabhighlight"
  name "Zilla Slab Highlight"
  homepage "https:fonts.google.comspecimenZilla+Slab+Highlight"

  font "ZillaSlabHighlight-Bold.ttf"
  font "ZillaSlabHighlight-Regular.ttf"

  # No zap stanza required
end