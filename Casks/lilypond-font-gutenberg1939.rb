cask 'lilypond-font-gutenberg1939' do
  version '1.0'
  sha256 "e8bccc90470a48f22b810c1b04358e53f9cfe488274c48a6fca97f6863102ffe"

  url "https:github.comOpenLilyPondFontsgutenberg1939archive2316a350aa58270afadc3b63576dde4e254d4bdf.tar.gz"
  name 'Gutenberg1939'
  desc "Gutenberg1939 Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsgutenberg1939"

  depends_on formula: "lilypond"

  source = Pathname("gutenberg1939-2316a350aa58270afadc3b63576dde4e254d4bdf")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfgutenberg1939-#{item}.otf", target: fonts_dir"otfgutenberg1939-#{item}.otf"
    font source"svggutenberg1939-#{item}.svg", target: fonts_dir"svggutenberg1939-#{item}.svg"
    font source"svggutenberg1939-#{item}.woff", target: fonts_dir"svggutenberg1939-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end