cask 'lilypond-font-haydn' do
  version '1.1'
  sha256 "cabaf4a98fa28e1555dfb042d60a048fa80cabd74bdf5b73d91fb3711931b778"

  url "https:github.comOpenLilyPondFontshaydnarchive9e7de8b0a722e650960abaae21c489e554ac02e0.tar.gz"
  name 'Haydn'
  desc "Haydn Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontshaydn"

  depends_on formula: "lilypond"

  source = Pathname("haydn-9e7de8b0a722e650960abaae21c489e554ac02e0")
  fonts_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}fonts")
  ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
    font source"otfhaydn-#{item}.otf", target: fonts_dir"otfhaydn-#{item}.otf"
    font source"svghaydn-#{item}.svg", target: fonts_dir"svghaydn-#{item}.svg"
    font source"svghaydn-#{item}.woff", target: fonts_dir"svghaydn-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end