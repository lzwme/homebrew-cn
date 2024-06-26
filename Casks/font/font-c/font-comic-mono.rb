cask "font-comic-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comdtinthcomic-mono-fontarchiverefsheadsmaster.tar.gz",
      verified: "github.comdtinthcomic-mono-font"
  name "Comic Mono"
  homepage "https:dtinth.github.iocomic-mono-font"

  font "comic-mono-font-masterComicMono.ttf"
  font "comic-mono-font-masterComicMono-Bold.ttf"

  # No zap stanza required
end