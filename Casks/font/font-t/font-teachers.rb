cask "font-teachers" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflteachers"
  name "Teachers"
  homepage "https:fonts.google.comspecimenTeachers"

  font "Teachers-Italic[wght].ttf"
  font "Teachers[wght].ttf"

  # No zap stanza required
end