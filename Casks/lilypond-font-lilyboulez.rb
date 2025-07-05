cask "lilypond-font-lilyboulez" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/lilyboulez/archive/refs/heads/master.tar.gz"
  name "LilyBoulez"
  desc "LilyBoulez Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/lilyboulez"

  depends_on formula: "lilypond"

  source = Pathname("lilyboulez-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source/"otf/lilyboulez-#{item}.otf", target: fonts_dir/"otf/lilyboulez-#{item}.otf"
    font source/"svg/lilyboulez-#{item}.svg", target: fonts_dir/"svg/lilyboulez-#{item}.svg"
    font source/"svg/lilyboulez-#{item}.woff", target: fonts_dir/"svg/lilyboulez-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end