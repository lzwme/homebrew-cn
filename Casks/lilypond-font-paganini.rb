cask "lilypond-font-paganini" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/paganini/archive/refs/heads/master.tar.gz"
  name "Paganini"
  desc "Paganini Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/paganini"

  depends_on formula: "lilypond"

  source = Pathname("paganini-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source/"otf/paganini-#{item}.otf", target: fonts_dir/"otf/paganini-#{item}.otf"
    font source/"svg/paganini-#{item}.svg", target: fonts_dir/"svg/paganini-#{item}.svg"
    font source/"svg/paganini-#{item}.woff", target: fonts_dir/"svg/paganini-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end