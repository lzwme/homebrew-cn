cask "font-dejavu-sans-mono-nerd-font" do
  version "3.2.1"
  sha256 "cf0f11c7e2e35df79c5a2f3b42073e8becd3597f23cbd4487de89c3546c17e70"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}DejaVuSansMono.zip"
  name "DejaVuSansM Nerd Font (DejaVu Sans Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "DejaVuSansMNerdFont-Bold.ttf"
  font "DejaVuSansMNerdFont-BoldOblique.ttf"
  font "DejaVuSansMNerdFont-Oblique.ttf"
  font "DejaVuSansMNerdFont-Regular.ttf"
  font "DejaVuSansMNerdFontMono-Bold.ttf"
  font "DejaVuSansMNerdFontMono-BoldOblique.ttf"
  font "DejaVuSansMNerdFontMono-Oblique.ttf"
  font "DejaVuSansMNerdFontMono-Regular.ttf"
  font "DejaVuSansMNerdFontPropo-Bold.ttf"
  font "DejaVuSansMNerdFontPropo-BoldOblique.ttf"
  font "DejaVuSansMNerdFontPropo-Oblique.ttf"
  font "DejaVuSansMNerdFontPropo-Regular.ttf"

  # No zap stanza required
end