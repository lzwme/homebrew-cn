cask "lilypond-font-bravura" do
  version "1.18"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontsbravuraarchiverefsheadsmaster.tar.gz"
  name "Bravura"
  desc "Bravura Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsbravura"

  depends_on formula: "lilypond"

  source = Pathname("bravura-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[Bravura BravuraText].each do |item|
    font source"otf#{item}.otf", target: fonts_dir"otf#{item}.otf"
    font source"woff#{item}.woff", target: fonts_dir"otf#{item}.woff"
    font source"svg#{item}.svg", target: fonts_dir"svg#{item}.svg"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end