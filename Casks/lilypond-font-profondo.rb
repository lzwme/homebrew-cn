cask "lilypond-font-profondo" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontsprofondoarchiverefsheadsmaster.tar.gz"
  name "Profondo"
  desc "Profondo Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsprofondo"

  depends_on formula: "lilypond"

  source = Pathname("profondo-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfprofondo-#{item}.otf", target: fonts_dir"otfprofondo-#{item}.otf"
    font source"svgprofondo-#{item}.svg", target: fonts_dir"svgprofondo-#{item}.svg"
    font source"svgprofondo-#{item}.woff", target: fonts_dir"svgprofondo-#{item}.woff"
  end
  font source"supplementary-fontsProfondoTupletNumbers.otf"

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end