cask "lilypond-font-sebastiano" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontssebastianoarchiverefsheadsmaster.tar.gz"
  name "Sebastiano"
  desc "Sebastiano Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontssebastiano"

  depends_on formula: "lilypond"

  source = Pathname("sebastiano-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfsebastiano-#{item}.otf", target: fonts_dir"otfsebastiano-#{item}.otf"
    font source"svgsebastiano-#{item}.svg", target: fonts_dir"svgsebastiano-#{item}.svg"
    font source"svgsebastiano-#{item}.woff", target: fonts_dir"svgsebastiano-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end