cask "font-inclusive-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinclusivesans"
  name "Inclusive Sans"
  desc "Contemporary neo-grotesques"
  homepage "https:fonts.google.comspecimenInclusive+Sans"

  font "InclusiveSans-Italic.ttf"
  font "InclusiveSans-Regular.ttf"

  # No zap stanza required
end