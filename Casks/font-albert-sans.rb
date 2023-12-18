cask "font-albert-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalbertsans"
  name "Albert Sans"
  desc "Modern geometric sans serif family"
  homepage "https:fonts.google.comspecimenAlbert+Sans"

  font "AlbertSans-Italic[wght].ttf"
  font "AlbertSans[wght].ttf"

  # No zap stanza required
end