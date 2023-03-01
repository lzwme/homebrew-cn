cask 'lilypond-font-bravura' do
  version '1.18'
  sha256 "b10a49af95a3f6b645685a560b8a97211519c1b6ee42ef79b95f4734373057cb"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/bravura/archive/53c774476c2060f379d9ef08569b8412b069b9ff.tar.gz"
  name 'Bravura'
  desc "Bravura Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/bravura"

  depends_on formula: "lilypond"

  source = Pathname("bravura-53c774476c2060f379d9ef08569b8412b069b9ff")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["Bravura", "BravuraText"].each do |item|
    font source/"otf/#{item}.otf", target: fonts_dir/"otf/#{item}.otf"
    font source/"woff/#{item}.woff", target: fonts_dir/"otf/#{item}.woff"
    font source/"svg/#{item}.svg", target: fonts_dir/"svg/#{item}.svg"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end