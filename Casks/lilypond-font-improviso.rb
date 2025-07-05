cask "lilypond-font-improviso" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/improviso/archive/refs/heads/master.tar.gz"
  name "Improviso"
  desc "Improviso Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/improviso"

  depends_on formula: "lilypond"

  source = Pathname("improviso-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/improviso-#{item}.otf", target: fonts_dir/"otf/improviso-#{item}.otf"
    font source/"svg/improviso-#{item}.svg", target: fonts_dir/"svg/improviso-#{item}.svg"
    font source/"svg/improviso-#{item}.woff", target: fonts_dir/"svg/improviso-#{item}.woff"
  end
  ["PeaMissywithaMarker.otf", "PermanentMarker.ttf", "Thickmarker.otf"].each do |item|
    font source/"supplementary-fonts/#{item}"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end