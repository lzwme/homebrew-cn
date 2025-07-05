cask "lilypond-font-sebastiano" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/sebastiano/archive/refs/heads/master.tar.gz"
  name "Sebastiano"
  desc "Sebastiano Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/sebastiano"

  depends_on formula: "lilypond"

  source = Pathname("sebastiano-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source/"otf/sebastiano-#{item}.otf", target: fonts_dir/"otf/sebastiano-#{item}.otf"
    font source/"svg/sebastiano-#{item}.svg", target: fonts_dir/"svg/sebastiano-#{item}.svg"
    font source/"svg/sebastiano-#{item}.woff", target: fonts_dir/"svg/sebastiano-#{item}.woff"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end