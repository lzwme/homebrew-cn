cask "lilypond-font-cadence" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontscadencearchiverefsheadsmaster.tar.gz"
  name "Cadence"
  desc "Cadence Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontscadence"

  depends_on formula: "lilypond"

  source = Pathname("cadence-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source"otfcadence-#{item}.otf", target: fonts_dir"otfcadence-#{item}.otf"
    font source"svgcadence-#{item}.svg", target: fonts_dir"svgcadence-#{item}.svg"
    font source"svgcadence-#{item}.woff", target: fonts_dir"svgcadence-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end