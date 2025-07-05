cask "lilypond-font-scorlatti" do
  version "1.1"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/scorlatti/archive/refs/heads/master.tar.gz"
  name "Scorlatti"
  desc "Scorlatti Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/scorlatti"

  depends_on formula: "lilypond"

  source = Pathname("scorlatti-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/scorlatti-#{item}.otf", target: fonts_dir/"otf/scorlatti-#{item}.otf"
    font source/"svg/scorlatti-#{item}.svg", target: fonts_dir/"svg/scorlatti-#{item}.svg"
    font source/"svg/scorlatti-#{item}.woff", target: fonts_dir/"svg/scorlatti-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end