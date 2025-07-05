cask "lilypond-font-gutenberg1939" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/gutenberg1939/archive/refs/heads/master.tar.gz"
  name "Gutenberg1939"
  desc "Gutenberg1939 Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/gutenberg1939"

  depends_on formula: "lilypond"

  source = Pathname("gutenberg1939-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/gutenberg1939-#{item}.otf", target: fonts_dir/"otf/gutenberg1939-#{item}.otf"
    font source/"svg/gutenberg1939-#{item}.svg", target: fonts_dir/"svg/gutenberg1939-#{item}.svg"
    font source/"svg/gutenberg1939-#{item}.woff", target: fonts_dir/"svg/gutenberg1939-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end