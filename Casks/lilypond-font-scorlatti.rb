cask "lilypond-font-scorlatti" do
  version "1.1"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontsscorlattiarchiverefsheadsmaster.tar.gz"
  name "Scorlatti"
  desc "Scorlatti Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsscorlatti"

  depends_on formula: "lilypond"

  source = Pathname("scorlatti-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfscorlatti-#{item}.otf", target: fonts_dir"otfscorlatti-#{item}.otf"
    font source"svgscorlatti-#{item}.svg", target: fonts_dir"svgscorlatti-#{item}.svg"
    font source"svgscorlatti-#{item}.woff", target: fonts_dir"svgscorlatti-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end