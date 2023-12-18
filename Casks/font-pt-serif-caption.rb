cask "font-pt-serif-caption" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflptserifcaption"
  name "PT Serif Caption"
  homepage "https:fonts.google.comspecimenPT+Serif+Caption"

  font "PT_Serif-Caption-Web-Italic.ttf"
  font "PT_Serif-Caption-Web-Regular.ttf"

  # No zap stanza required
end