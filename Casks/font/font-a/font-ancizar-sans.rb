cask "font-ancizar-sans" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts.git",
      verified:  "github.com/google/fonts",
      branch:    "main",
      only_path: "ofl/ancizarsans"
  name "Ancizar Sans"
  homepage "https://fonts.google.com/specimen/Ancizar+Sans"

  font "AncizarSans-Italic[wght].ttf"
  font "AncizarSans[wght].ttf"

  # No zap stanza required
end