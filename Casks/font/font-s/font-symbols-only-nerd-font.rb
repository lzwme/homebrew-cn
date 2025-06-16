cask "font-symbols-only-nerd-font" do
  version "3.4.0"
  sha256 "8e617904b980fe3648a4b116808788fe50c99d2d495376cb7c0badbd8a564c47"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}NerdFontsSymbolsOnly.zip"
  name "Symbols Nerd Font (Symbols Only)"
  homepage "https:github.comryanoasisnerd-fonts"

  no_autobump! because: :bumped_by_upstream

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SymbolsNerdFont-Regular.ttf"
  font "SymbolsNerdFontMono-Regular.ttf"

  # No zap stanza required
end