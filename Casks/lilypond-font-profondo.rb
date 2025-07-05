cask "lilypond-font-profondo" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/profondo/archive/refs/heads/master.tar.gz"
  name "Profondo"
  desc "Profondo Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/profondo"

  depends_on formula: "lilypond"

  source = Pathname("profondo-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/profondo-#{item}.otf", target: fonts_dir/"otf/profondo-#{item}.otf"
    font source/"svg/profondo-#{item}.svg", target: fonts_dir/"svg/profondo-#{item}.svg"
    font source/"svg/profondo-#{item}.woff", target: fonts_dir/"svg/profondo-#{item}.woff"
  end
  font source/"supplementary-fonts/ProfondoTupletNumbers.otf"

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end