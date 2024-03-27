cask "lilypond-font-lilyjazz" do
  version "2.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontslilyjazzarchiverefsheadsmaster.tar.gz"
  name "LilyJAZZ"
  desc "LilyJAZZ Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontslilyjazz"

  depends_on formula: "lilypond"

  source = Pathname("lilyjazz-master")
  lily_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}")
  fonts_dir = lily_dir"fonts"
  %w[11 13 14 16 18 20 23 26 brace].each do |item|
    font source"otflilyjazz-#{item}.otf", target: fonts_dir"otflilyjazz-#{item}.otf"
    font source"svglilyjazz-#{item}.svg", target: fonts_dir"svglilyjazz-#{item}.svg"
    font source"svglilyjazz-#{item}.woff", target: fonts_dir"svglilyjazz-#{item}.woff"
  end

  ["jazzchords.ily", "jazzextras.ily", "lilyjazz.ily"].each do |item|
    artifact source"stylesheet#{item}", target: lily_dir"ly#{item}"
  end
  font source"supplementary-fileslilyjazz-chordlilyjazz-chord.otf"
  font source"supplementary-fileslilyjazz-textlilyjazz-text.otf"

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end