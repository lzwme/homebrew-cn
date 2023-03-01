cask 'lilypond-font-improviso' do
  version '1.0'
  sha256 "9eae14b235c4e95dd85f8064598d10182ff7c05755f8776835e4813d76475e38"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/improviso/archive/0753f5a102ac6ee59f9660dfe41b5826c93c993e.tar.gz"
  name 'Improviso'
  desc "Improviso Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/improviso"

  depends_on formula: "lilypond"

  source = Pathname("improviso-0753f5a102ac6ee59f9660dfe41b5826c93c993e")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source/"otf/improviso-#{item}.otf", target: fonts_dir/"otf/improviso-#{item}.otf"
    font source/"svg/improviso-#{item}.svg", target: fonts_dir/"svg/improviso-#{item}.svg"
    font source/"svg/improviso-#{item}.woff", target: fonts_dir/"svg/improviso-#{item}.woff"
  end
  ["PeaMissywithaMarker.otf", "PermanentMarker.ttf", "Thickmarker.otf"].each do |item|
    font source/"supplementary-fonts/#{item}"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end