cask "lilypond-font-gonville" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontsgonvillearchiverefsheadsmaster.tar.gz"
  name "Gonville"
  desc "Gonville Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsgonville"

  depends_on formula: "lilypond"

  source = Pathname("gonville-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otfgonville-#{item}.otf", target: fonts_dir"otfgonville-#{item}.otf"
    font source"svggonville-#{item}.svg", target: fonts_dir"svggonville-#{item}.svg"
    font source"svggonville-#{item}.woff", target: fonts_dir"svggonville-#{item}.woff" if item != "brace"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end