cask 'lilypond-font-ross' do
  version '1.1'
  sha256 "1c73257ee4917e12400b0e3c860a9b788e5417577383831e04d7848574cdffba"

  url "https:github.comOpenLilyPondFontsrossarchiveaa8127fe5668e6069a62d2e8c5f5eb6d028b481c.tar.gz"
  name 'Ross'
  desc "Ross Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsross"

  depends_on formula: "lilypond"

  source = Pathname("ross-aa8127fe5668e6069a62d2e8c5f5eb6d028b481c")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfross-#{item}.otf", target: fonts_dir"otfross-#{item}.otf"
    font source"svgross-#{item}.svg", target: fonts_dir"svgross-#{item}.svg"
    font source"svgross-#{item}.woff", target: fonts_dir"svgross-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end