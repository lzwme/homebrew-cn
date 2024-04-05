cask "font-gohufont-nerd-font" do
  version "3.2.0"
  sha256 "3610039a4579b299cde397b5283cb48a01c65d2f7a62479eb914d78a52d0de3b"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Gohu.zip"
  name "GohuFont  Nerd Font families (Gohu)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "GohuFont11NerdFont-Regular.ttf"
  font "GohuFont11NerdFontMono-Regular.ttf"
  font "GohuFont11NerdFontPropo-Regular.ttf"
  font "GohuFont14NerdFont-Regular.ttf"
  font "GohuFont14NerdFontMono-Regular.ttf"
  font "GohuFont14NerdFontPropo-Regular.ttf"
  font "GohuFontuni11NerdFont-Regular.ttf"
  font "GohuFontuni11NerdFontMono-Regular.ttf"
  font "GohuFontuni11NerdFontPropo-Regular.ttf"
  font "GohuFontuni14NerdFont-Regular.ttf"
  font "GohuFontuni14NerdFontMono-Regular.ttf"
  font "GohuFontuni14NerdFontPropo-Regular.ttf"

  # No zap stanza required
end