cask "lilypond-font-haydn" do
  version "1.1"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontshaydnarchiverefsheadsmaster.tar.gz"
  name "Haydn"
  desc "Haydn Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontshaydn"

  depends_on formula: "lilypond"

  source = Pathname("haydn-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfhaydn-#{item}.otf", target: fonts_dir"otfhaydn-#{item}.otf"
    font source"svghaydn-#{item}.svg", target: fonts_dir"svghaydn-#{item}.svg"
    font source"svghaydn-#{item}.woff", target: fonts_dir"svghaydn-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end