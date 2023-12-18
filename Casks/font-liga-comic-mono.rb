cask "font-liga-comic-mono" do
  version :latest
  sha256 :no_check

  url "https:codeload.github.comwayoucomic-mono-fontzipmaster"
  name "Liga Comic Mono"
  desc "Legible monospace font with programming ligatures"
  homepage "https:github.comwayoucomic-mono-font"

  font "comic-mono-font-masterLigaComicMono.ttf"
  font "comic-mono-font-masterLigaComicMono-Bold.ttf"

  # No zap stanza required
end