cask "font-fantasque-sans-mono-nerd-font" do
  version "3.2.0"
  sha256 "f3d3c627021d1fa96b9630d30b897efb9f2a9844de12332470743b668520e719"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}FantasqueSansMono.zip"
  name "FantasqueSansM Nerd Font (Fantasque Sans Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "FantasqueSansMNerdFont-Bold.ttf"
  font "FantasqueSansMNerdFont-BoldItalic.ttf"
  font "FantasqueSansMNerdFont-Italic.ttf"
  font "FantasqueSansMNerdFont-Regular.ttf"
  font "FantasqueSansMNerdFontMono-Bold.ttf"
  font "FantasqueSansMNerdFontMono-BoldItalic.ttf"
  font "FantasqueSansMNerdFontMono-Italic.ttf"
  font "FantasqueSansMNerdFontMono-Regular.ttf"
  font "FantasqueSansMNerdFontPropo-Bold.ttf"
  font "FantasqueSansMNerdFontPropo-BoldItalic.ttf"
  font "FantasqueSansMNerdFontPropo-Italic.ttf"
  font "FantasqueSansMNerdFontPropo-Regular.ttf"

  # No zap stanza required
end