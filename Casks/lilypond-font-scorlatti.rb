cask 'lilypond-font-scorlatti' do
  version '1.1'
  sha256 "c9540e8d33a3964dfe4ddb3e1c64d86a9c9a51b0cdba3d4774071657045d1d73"

  url "https:github.comOpenLilyPondFontsscorlattiarchive1db87dac9105cd456f5174ba6ca668c94cc553be.tar.gz"
  name 'Scorlatti'
  desc "Scorlatti Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsscorlatti"

  depends_on formula: "lilypond"

  source = Pathname("scorlatti-1db87dac9105cd456f5174ba6ca668c94cc553be")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfscorlatti-#{item}.otf", target: fonts_dir"otfscorlatti-#{item}.otf"
    font source"svgscorlatti-#{item}.svg", target: fonts_dir"svgscorlatti-#{item}.svg"
    font source"svgscorlatti-#{item}.woff", target: fonts_dir"svgscorlatti-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end