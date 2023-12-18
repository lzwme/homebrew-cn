cask "font-symbols-only-nerd-font" do
  version "3.1.1"
  sha256 "8c64613efe0c5d11664a931d241e756ea422cf4ad18d799f1cb5e43171226a76"

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