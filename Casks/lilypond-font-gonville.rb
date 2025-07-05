cask "lilypond-font-gonville" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/gonville/archive/refs/heads/master.tar.gz"
  name "Gonville"
  desc "Gonville Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/gonville"

  depends_on formula: "lilypond"

  source = Pathname("gonville-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/gonville-#{item}.otf", target: fonts_dir/"otf/gonville-#{item}.otf"
    font source/"svg/gonville-#{item}.svg", target: fonts_dir/"svg/gonville-#{item}.svg"
    font source/"svg/gonville-#{item}.woff", target: fonts_dir/"svg/gonville-#{item}.woff" if item != "brace"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end