cask "lilypond-font-lilyboulez" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontslilyboulezarchiverefsheadsmaster.tar.gz"
  name "LilyBoulez"
  desc "LilyBoulez Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontslilyboulez"

  depends_on formula: "lilypond"

  source = Pathname("lilyboulez-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source"otflilyboulez-#{item}.otf", target: fonts_dir"otflilyboulez-#{item}.otf"
    font source"svglilyboulez-#{item}.svg", target: fonts_dir"svglilyboulez-#{item}.svg"
    font source"svglilyboulez-#{item}.woff", target: fonts_dir"svglilyboulez-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end