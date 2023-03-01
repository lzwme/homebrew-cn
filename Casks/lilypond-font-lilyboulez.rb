cask 'lilypond-font-lilyboulez' do
  version '1.0'
  sha256 "b33ccb335256b206681937f80ceb045f96fb19d64345a36bdaa5125eb660c7f4"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/lilyboulez/archive/e8455fc8401d8f4fd7124d29a55529db19372e02.tar.gz"
  name 'LilyBoulez'
  desc "LilyBoulez Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/lilyboulez"

  depends_on formula: "lilypond"

  source = Pathname("lilyboulez-e8455fc8401d8f4fd7124d29a55529db19372e02")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26"].each do |item|
    font source/"otf/lilyboulez-#{item}.otf", target: fonts_dir/"otf/lilyboulez-#{item}.otf"
    font source/"svg/lilyboulez-#{item}.svg", target: fonts_dir/"svg/lilyboulez-#{item}.svg"
    font source/"svg/lilyboulez-#{item}.woff", target: fonts_dir/"svg/lilyboulez-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end