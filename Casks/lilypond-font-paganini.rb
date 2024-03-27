cask "lilypond-font-paganini" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontspaganiniarchiverefsheadsmaster.tar.gz"
  name "Paganini"
  desc "Paganini Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontspaganini"

  depends_on formula: "lilypond"

  source = Pathname("paganini-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source"otfpaganini-#{item}.otf", target: fonts_dir"otfpaganini-#{item}.otf"
    font source"svgpaganini-#{item}.svg", target: fonts_dir"svgpaganini-#{item}.svg"
    font source"svgpaganini-#{item}.woff", target: fonts_dir"svgpaganini-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end