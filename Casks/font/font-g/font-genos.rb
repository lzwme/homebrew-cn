cask "font-genos" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgenos"
  name "Genos"
  desc "Modern display font with a futuristic feel"
  homepage "https:fonts.google.comspecimenGenos"

  font "Genos-Italic[wght].ttf"
  font "Genos[wght].ttf"

  # No zap stanza required
end