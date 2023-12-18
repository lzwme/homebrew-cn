cask 'lilypond-font-lilyjazz' do
      version '2.0'
      sha256 "e76afcd2d7e61fb80e8cb028632be7c8bf39748781de859329f142e0e40ffb07"

      url "https:github.comOpenLilyPondFontslilyjazzarchive8fa7d5548ec553eea9b2189a652e089e1eec4209.tar.gz"
      name 'LilyJAZZ'
      desc "LilyJAZZ Font for LilyPond"
      homepage "https:github.comOpenLilyPondFontslilyjazz"

      depends_on formula: "lilypond"

      source = Pathname("lilyjazz-8fa7d5548ec553eea9b2189a652e089e1eec4209")
      lily_dir = Pathname("#{Formula['lilypond'].prefix}sharelilypond#{Formula['lilypond'].version}")
      fonts_dir = lily_dir"fonts"
      ["11", "13", "14", "16", "18", "20", "23", "26", "brace"].each do |item|
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