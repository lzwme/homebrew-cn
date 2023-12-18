cask "font-comic-mono" do
  version :latest
  sha256 :no_check

  url "https:codeload.github.comdtinthcomic-mono-fontzipmaster",
      verified: "codeload.github.comdtinthcomic-mono-font"
  name "Comic Mono"
  desc "Legible monospace font"
  homepage "https:dtinth.github.iocomic-mono-font"

  font "comic-mono-font-masterComicMono.ttf"
  font "comic-mono-font-masterComicMono-Bold.ttf"

  # No zap stanza required
end