cask 'lilypond-font-cadence' do
  version '1.0'
  sha256 "aa340618687c554a3128767c9bdbcc39df81e42b93ce2f853f1c0fb840ce8eef"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/cadence/archive/1cc0fb7bcdc72f2e6e6e0f38efd813de502b4216.tar.gz"
  name 'Cadence'
  desc "Cadence Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/cadence"

  depends_on formula: "lilypond"

  source = Pathname("cadence-1cc0fb7bcdc72f2e6e6e0f38efd813de502b4216")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26"].each do |item|
    font source/"otf/cadence-#{item}.otf", target: fonts_dir/"otf/cadence-#{item}.otf"
    font source/"svg/cadence-#{item}.svg", target: fonts_dir/"svg/cadence-#{item}.svg"
    font source/"svg/cadence-#{item}.woff", target: fonts_dir/"svg/cadence-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end