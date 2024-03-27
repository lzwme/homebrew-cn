cask "lilypond-font-ross" do
  version "1.1"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontsrossarchiverefsheadsmaster.tar.gz"
  name "Ross"
  desc "Ross Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsross"

  depends_on formula: "lilypond"

  source = Pathname("ross-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfross-#{item}.otf", target: fonts_dir"otfross-#{item}.otf"
    font source"svgross-#{item}.svg", target: fonts_dir"svgross-#{item}.svg"
    font source"svgross-#{item}.woff", target: fonts_dir"svgross-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end