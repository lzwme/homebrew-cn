cask 'lilypond-font-sebastiano' do
  version '1.0'
  sha256 "dffb486d03701a68370e521c584c356adf1ef87998178b9567da80dd668e88cd"

  url "https:github.comOpenLilyPondFontssebastianoarchive44bf262f20dbb8024bcda38471ddbfb018f01378.tar.gz"
  name 'Sebastiano'
  desc "Sebastiano Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontssebastiano"

  depends_on formula: "lilypond"

  source = Pathname("sebastiano-44bf262f20dbb8024bcda38471ddbfb018f01378")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfsebastiano-#{item}.otf", target: fonts_dir"otfsebastiano-#{item}.otf"
    font source"svgsebastiano-#{item}.svg", target: fonts_dir"svgsebastiano-#{item}.svg"
    font source"svgsebastiano-#{item}.woff", target: fonts_dir"svgsebastiano-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end