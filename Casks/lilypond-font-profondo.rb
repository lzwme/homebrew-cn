cask 'lilypond-font-profondo' do
  version '1.0'
  sha256 "c0156f9c785d02fcb8e79b9bcdf8b36ffb7bf427536718d8ffc45319c143aee4"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/profondo/archive/8cfb668d16baaae167e634006b3c621db8f299c6.tar.gz"
  name 'Profondo'
  desc "Profondo Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/profondo"

  depends_on formula: "lilypond"

  source = Pathname("profondo-8cfb668d16baaae167e634006b3c621db8f299c6")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source/"otf/profondo-#{item}.otf", target: fonts_dir/"otf/profondo-#{item}.otf"
    font source/"svg/profondo-#{item}.svg", target: fonts_dir/"svg/profondo-#{item}.svg"
    font source/"svg/profondo-#{item}.woff", target: fonts_dir/"svg/profondo-#{item}.woff"
  end
  font source/"supplementary-fonts/ProfondoTupletNumbers.otf"

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end