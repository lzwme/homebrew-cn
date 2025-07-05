cask "lilypond-font-lilyjazz" do
  version "2.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/lilyjazz/archive/refs/heads/master.tar.gz"
  name "LilyJAZZ"
  desc "LilyJAZZ Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/lilyjazz"

  depends_on formula: "lilypond"

  source = Pathname("lilyjazz-master")
  lily_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}")
  fonts_dir = lily_dir/"fonts"
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/lilyjazz-#{item}.otf", target: fonts_dir/"otf/lilyjazz-#{item}.otf"
    font source/"svg/lilyjazz-#{item}.svg", target: fonts_dir/"svg/lilyjazz-#{item}.svg"
    font source/"svg/lilyjazz-#{item}.woff", target: fonts_dir/"svg/lilyjazz-#{item}.woff"
  end

  ["jazzchords.ily", "jazzextras.ily", "lilyjazz.ily"].each do |item|
    artifact source/"stylesheet/#{item}", target: lily_dir/"ly/#{item}"
  end
  font source/"supplementary-files/lilyjazz-chord/lilyjazz-chord.otf"
  font source/"supplementary-files/lilyjazz-text/lilyjazz-text.otf"

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end