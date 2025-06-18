cask "font-bitstream-vera-sans-mono-nerd-font" do
  version "3.4.0"
  sha256 "e245e428e58c6b4b74365f89bae9157c54377cfb7f266be223c25a60d1042f45"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}BitstreamVeraSansMono.zip"
  name "BitstromWera Nerd Font (Bitstream Vera Sans Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  font "BitstromWeraNerdFont-Bold.ttf"
  font "BitstromWeraNerdFont-BoldOblique.ttf"
  font "BitstromWeraNerdFont-Oblique.ttf"
  font "BitstromWeraNerdFont-Regular.ttf"
  font "BitstromWeraNerdFontMono-Bold.ttf"
  font "BitstromWeraNerdFontMono-BoldOblique.ttf"
  font "BitstromWeraNerdFontMono-Oblique.ttf"
  font "BitstromWeraNerdFontMono-Regular.ttf"
  font "BitstromWeraNerdFontPropo-Bold.ttf"
  font "BitstromWeraNerdFontPropo-BoldOblique.ttf"
  font "BitstromWeraNerdFontPropo-Oblique.ttf"
  font "BitstromWeraNerdFontPropo-Regular.ttf"

  # No zap stanza required
end