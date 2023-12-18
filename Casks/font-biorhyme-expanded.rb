cask "font-biorhyme-expanded" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbiorhymeexpanded"
  name "BioRhyme Expanded"
  homepage "https:fonts.google.comspecimenBioRhyme+Expanded"

  font "BioRhymeExpanded-Bold.ttf"
  font "BioRhymeExpanded-ExtraBold.ttf"
  font "BioRhymeExpanded-ExtraLight.ttf"
  font "BioRhymeExpanded-Light.ttf"
  font "BioRhymeExpanded-Regular.ttf"

  # No zap stanza required
end