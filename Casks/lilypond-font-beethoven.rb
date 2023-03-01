cask 'lilypond-font-beethoven' do
  version '1.1'
  sha256 "26dacde1ca4b9004938851e6c65c3d171194e3c3c1a284c3fd0b1da3c751a115"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/beethoven/archive/669f400ce0edf7bccd817f10e2015ead78966578.tar.gz"
  name 'Beethoven'
  desc "Beethoven Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/beethoven"

  depends_on formula: "lilypond"

  source = Pathname("beethoven-669f400ce0edf7bccd817f10e2015ead78966578")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source/"otf/beethoven-#{item}.otf", target: fonts_dir/"otf/beethoven-#{item}.otf"
    font source/"svg/beethoven-#{item}.svg", target: fonts_dir/"svg/beethoven-#{item}.svg"
    font source/"svg/beethoven-#{item}.woff", target: fonts_dir/"svg/beethoven-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end