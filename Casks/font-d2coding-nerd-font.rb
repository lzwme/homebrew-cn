cask "font-d2coding-nerd-font" do
  version "3.2.0"
  sha256 "36ddd0942c3178cd0aafa0c5b69da4e65257a198464019cae956ae6380586d99"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}D2Coding.zip"
  name "D2CodingLigature Nerd Font (D2Coding)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "D2CodingLigatureNerdFont-Bold.ttf"
  font "D2CodingLigatureNerdFont-Regular.ttf"
  font "D2CodingLigatureNerdFontMono-Bold.ttf"
  font "D2CodingLigatureNerdFontMono-Regular.ttf"
  font "D2CodingLigatureNerdFontPropo-Bold.ttf"
  font "D2CodingLigatureNerdFontPropo-Regular.ttf"

  # No zap stanza required
end