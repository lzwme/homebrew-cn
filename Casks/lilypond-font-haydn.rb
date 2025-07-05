cask "lilypond-font-haydn" do
  version "1.1"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/haydn/archive/refs/heads/master.tar.gz"
  name "Haydn"
  desc "Haydn Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/haydn"

  depends_on formula: "lilypond"

  source = Pathname("haydn-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/haydn-#{item}.otf", target: fonts_dir/"otf/haydn-#{item}.otf"
    font source/"svg/haydn-#{item}.svg", target: fonts_dir/"svg/haydn-#{item}.svg"
    font source/"svg/haydn-#{item}.woff", target: fonts_dir/"svg/haydn-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end