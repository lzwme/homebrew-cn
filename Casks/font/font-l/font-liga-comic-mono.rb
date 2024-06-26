cask "font-liga-comic-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comwayoucomic-mono-fontarchiverefsheadsmaster.tar.gz"
  name "Liga Comic Mono"
  homepage "https:github.comwayoucomic-mono-font"

  font "comic-mono-font-masterLigaComicMono.ttf"
  font "comic-mono-font-masterLigaComicMono-Bold.ttf"

  # No zap stanza required
end