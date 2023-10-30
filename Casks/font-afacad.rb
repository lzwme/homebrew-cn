cask "font-afacad" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts.git",
      branch:    "main",
      only_path: "ofl/afacad"
  name "Afacad"
  homepage "https://github.com/Dicotype/Afacad"

  font "Afacad-Italic[wght].ttf"
  font "Afacad[wght].ttf"

  # No zap stanza required
end