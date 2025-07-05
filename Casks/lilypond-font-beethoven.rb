cask "lilypond-font-beethoven" do
  version "1.1"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/beethoven/archive/refs/heads/master.tar.gz"
  name "Beethoven"
  desc "Beethoven Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/beethoven"

  depends_on formula: "lilypond"

  source = Pathname("beethoven-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/beethoven-#{item}.otf", target: fonts_dir/"otf/beethoven-#{item}.otf"
    font source/"svg/beethoven-#{item}.svg", target: fonts_dir/"svg/beethoven-#{item}.svg"
    font source/"svg/beethoven-#{item}.woff", target: fonts_dir/"svg/beethoven-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end