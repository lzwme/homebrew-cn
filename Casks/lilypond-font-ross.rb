cask "lilypond-font-ross" do
  version "1.1"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/ross/archive/refs/heads/master.tar.gz"
  name "Ross"
  desc "Ross Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/ross"

  depends_on formula: "lilypond"

  source = Pathname("ross-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/ross-#{item}.otf", target: fonts_dir/"otf/ross-#{item}.otf"
    font source/"svg/ross-#{item}.svg", target: fonts_dir/"svg/ross-#{item}.svg"
    font source/"svg/ross-#{item}.woff", target: fonts_dir/"svg/ross-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end