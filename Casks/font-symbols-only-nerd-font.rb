cask "font-symbols-only-nerd-font" do
  version "3.2.0"
  sha256 "025e64ad8afacb11cbb2bd14b1aea97966ccf0b67dd8ffa1cf4f179cdbd2863c"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}NerdFontsSymbolsOnly.zip"
  name "Symbols Nerd Font (Symbols Only)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SymbolsNerdFont-Regular.ttf"
  font "SymbolsNerdFontMono-Regular.ttf"

  # No zap stanza required
end