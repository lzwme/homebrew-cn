cask "lilypond-font-cadence" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/cadence/archive/refs/heads/master.tar.gz"
  name "Cadence"
  desc "Cadence Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/cadence"

  depends_on formula: "lilypond"

  source = Pathname("cadence-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source/"otf/cadence-#{item}.otf", target: fonts_dir/"otf/cadence-#{item}.otf"
    font source/"svg/cadence-#{item}.svg", target: fonts_dir/"svg/cadence-#{item}.svg"
    font source/"svg/cadence-#{item}.woff", target: fonts_dir/"svg/cadence-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end