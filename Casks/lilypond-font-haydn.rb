cask 'lilypond-font-haydn' do
  version '1.1'
  sha256 "cabaf4a98fa28e1555dfb042d60a048fa80cabd74bdf5b73d91fb3711931b778"

  url "https://ghproxy.com/https://github.com/OpenLilyPondFonts/haydn/archive/9e7de8b0a722e650960abaae21c489e554ac02e0.tar.gz"
  name 'Haydn'
  desc "Haydn Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/haydn"

  depends_on formula: "lilypond"

  source = Pathname("haydn-9e7de8b0a722e650960abaae21c489e554ac02e0")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}/share/lilypond/#{Formula['lilypond'].version}/fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source/"otf/haydn-#{item}.otf", target: fonts_dir/"otf/haydn-#{item}.otf"
    font source/"svg/haydn-#{item}.svg", target: fonts_dir/"svg/haydn-#{item}.svg"
    font source/"svg/haydn-#{item}.woff", target: fonts_dir/"svg/haydn-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end