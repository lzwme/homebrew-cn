cask 'lilypond-font-gonville' do
  version '1.0'
  sha256 "3bfd398a2c524d21134de1d00aedef78c641472760db83f4a4ac0c17394c3565"

  url "https:github.comOpenLilyPondFontsgonvillearchivea638bc9d2813ff226bdc70436a137e4d69d8de29.tar.gz"
  name 'Gonville'
  desc "Gonville Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsgonville"

  depends_on formula: "lilypond"

  source = Pathname("gonville-a638bc9d2813ff226bdc70436a137e4d69d8de29")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfgonville-#{item}.otf", target: fonts_dir"otfgonville-#{item}.otf"
    font source"svggonville-#{item}.svg", target: fonts_dir"svggonville-#{item}.svg"
    font source"svggonville-#{item}.woff", target: fonts_dir"svggonville-#{item}.woff" unless item == "brace"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end