cask 'lilypond-font-sebastiano' do
  version '1.0'
  sha256 "dffb486d03701a68370e521c584c356adf1ef87998178b9567da80dd668e88cd"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/sebastiano/archive/44bf262f20dbb8024bcda38471ddbfb018f01378.tar.gz"
  name 'Sebastiano'
  desc "Sebastiano Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/sebastiano"

  depends_on formula: "lilypond"

  source = Pathname("sebastiano-44bf262f20dbb8024bcda38471ddbfb018f01378")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source/"otf/sebastiano-#{item}.otf", target: fonts_dir/"otf/sebastiano-#{item}.otf"
    font source/"svg/sebastiano-#{item}.svg", target: fonts_dir/"svg/sebastiano-#{item}.svg"
    font source/"svg/sebastiano-#{item}.woff", target: fonts_dir/"svg/sebastiano-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end