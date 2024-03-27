cask "lilypond-font-beethoven" do
  version "1.1"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontsbeethovenarchiverefsheadsmaster.tar.gz"
  name "Beethoven"
  desc "Beethoven Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsbeethoven"

  depends_on formula: "lilypond"

  source = Pathname("beethoven-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfbeethoven-#{item}.otf", target: fonts_dir"otfbeethoven-#{item}.otf"
    font source"svgbeethoven-#{item}.svg", target: fonts_dir"svgbeethoven-#{item}.svg"
    font source"svgbeethoven-#{item}.woff", target: fonts_dir"svgbeethoven-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end