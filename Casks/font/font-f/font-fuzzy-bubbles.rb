cask "font-fuzzy-bubbles" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfuzzybubbles"
  name "Fuzzy Bubbles"
  homepage "https:fonts.google.comspecimenFuzzy+Bubbles"

  font "FuzzyBubbles-Bold.ttf"
  font "FuzzyBubbles-Regular.ttf"

  # No zap stanza required
end