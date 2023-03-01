cask 'lilypond-font-paganini' do
  version '1.0'
  sha256 "3f3cf86d86d1531878fbd4da1ad3768daf40dd34c5ba01a5039e75d9fe4796b2"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/paganini/archive/8e4e55a2c9ae81fe6bc0ce83a5388a9e4c5f7530.tar.gz"
  name 'Paganini'
  desc "Paganini Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/paganini"

  depends_on formula: "lilypond"

  source = Pathname("paganini-8e4e55a2c9ae81fe6bc0ce83a5388a9e4c5f7530")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26"].each do |item|
    font source/"otf/paganini-#{item}.otf", target: fonts_dir/"otf/paganini-#{item}.otf"
    font source/"svg/paganini-#{item}.svg", target: fonts_dir/"svg/paganini-#{item}.svg"
    font source/"svg/paganini-#{item}.woff", target: fonts_dir/"svg/paganini-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end