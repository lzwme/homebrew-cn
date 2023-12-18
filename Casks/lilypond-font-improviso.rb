cask 'lilypond-font-improviso' do
  version '1.0'
  sha256 "9eae14b235c4e95dd85f8064598d10182ff7c05755f8776835e4813d76475e38"

  url "https:github.comOpenLilyPondFontsimprovisoarchive0753f5a102ac6ee59f9660dfe41b5826c93c993e.tar.gz"
  name 'Improviso'
  desc "Improviso Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontsimproviso"

  depends_on formula: "lilypond"

  source = Pathname("improviso-0753f5a102ac6ee59f9660dfe41b5826c93c993e")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfimproviso-#{item}.otf", target: fonts_dir"otfimproviso-#{item}.otf"
    font source"svgimproviso-#{item}.svg", target: fonts_dir"svgimproviso-#{item}.svg"
    font source"svgimproviso-#{item}.woff", target: fonts_dir"svgimproviso-#{item}.woff"
  end
  ["PeaMissywithaMarker.otf", "PermanentMarker.ttf", "Thickmarker.otf"].each do |item|
    font source"supplementary-fonts#{item}"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end