cask 'lilypond-font-gonville' do
  version '1.0'
  sha256 "3bfd398a2c524d21134de1d00aedef78c641472760db83f4a4ac0c17394c3565"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/gonville/archive/a638bc9d2813ff226bdc70436a137e4d69d8de29.tar.gz"
  name 'Gonville'
  desc "Gonville Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/gonville"

  depends_on formula: "lilypond"

  source = Pathname("gonville-a638bc9d2813ff226bdc70436a137e4d69d8de29")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source/"otf/gonville-#{item}.otf", target: fonts_dir/"otf/gonville-#{item}.otf"
    font source/"svg/gonville-#{item}.svg", target: fonts_dir/"svg/gonville-#{item}.svg"
    font source/"svg/gonville-#{item}.woff", target: fonts_dir/"svg/gonville-#{item}.woff" unless item == "brace"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end